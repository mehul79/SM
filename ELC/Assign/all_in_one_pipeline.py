import os
import io
import zipfile
import time
import requests
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import re
import joblib
from pathlib import Path
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix, ConfusionMatrixDisplay
import nltk
nltk.download('punkt', quiet=True)

# ---------- Config ----------
DATA_DIR = Path("data")
DATA_DIR.mkdir(exist_ok=True)
SMS_ZIP_URL = "http://archive.ics.uci.edu/ml/machine-learning-databases/00228/smsspamcollection.zip"
SMS_ZIP_PATH = DATA_DIR / "smsspamcollection.zip"
SMS_TXT_PATH = DATA_DIR / "SMSSpamCollection"   # file inside zip
MODEL_DIR = Path("models"); MODEL_DIR.mkdir(exist_ok=True)
VECT_PATH = MODEL_DIR / "tfidf_vectorizer.joblib"
MODEL_PATH = MODEL_DIR / "text_lr.joblib"
RANDOM_SEED = 42

# ---------- Helper functions ----------
def download_sms_if_needed():
    if (DATA_DIR / "SMSSpamCollection").exists():
        print("SMS dataset already present.")
        return
    print("Downloading SMS Spam dataset from UCI...")
    r = requests.get(SMS_ZIP_URL, timeout=30)
    r.raise_for_status()
    with open(SMS_ZIP_PATH, "wb") as f:
        f.write(r.content)
    with zipfile.ZipFile(SMS_ZIP_PATH, "r") as z:
        z.extractall(DATA_DIR)
    print("Downloaded and extracted to", DATA_DIR)

def load_sms_dataframe():
    txt_file = DATA_DIR / "SMSSpamCollection"
    if not txt_file.exists():
        raise FileNotFoundError("Dataset file missing; run download_sms_if_needed()")
    # file format: <label>\t<message>
    df = pd.read_csv(txt_file, sep='\t', header=None, names=['label', 'text'], quoting=3)
    # normalize labels to binary 1=spam, 0=ham
    df['label_num'] = (df['label'].str.lower() == 'spam').astype(int)
    return df

def clean_text(s):
    # simple cleaning: lower, remove non-alphanum, strip
    s = str(s).lower()
    s = re.sub(r'http\S+','', s)          # remove URLs
    s = re.sub(r'[^a-z0-9\s]', ' ', s)    # keep alphanum
    s = re.sub(r'\s+', ' ', s).strip()
    return s

# ---------- Pipeline ----------
def main():
    print("=== START: All-in-one text pipeline ===")
    # 1) Download dataset
    try:
        download_sms_if_needed()
    except Exception as e:
        print("Warning: automatic download failed:", e)
        print("If running in Kaggle with internet disabled, upload the 'SMSSpamCollection' file into /kaggle/working/data/")
        return

    # 2) Load
    df = load_sms_dataframe()
    print("Loaded SMS dataset with shape:", df.shape)
    print(df.label.value_counts())

    # 3) EDA quick stats
    df['length'] = df['text'].str.split().apply(len)
    print("\nText length (words) stats:")
    print(df['length'].describe())

    # Plot distribution (will pop up in notebook or saved as png)
    try:
        plt.figure(figsize=(6,3))
        df['length'].hist(bins=30)
        plt.title("SMS word length distribution")
        plt.xlabel("words")
        plt.tight_layout()
        plt.savefig("sms_length_hist.png", dpi=120)
        print("Saved sms_length_hist.png")
    except Exception as e:
        print("Plot failed:", e)

    # 4) Preprocess text
    df['clean'] = df['text'].apply(clean_text)
    # quick sample
    print("\nSample raw -> clean:")
    for r in df.sample(3, random_state=RANDOM_SEED).itertuples():
        print("-", r.text, "->", r.clean)

    # 5) Feature extraction: TF-IDF
    vectorizer = TfidfVectorizer(max_features=4000, ngram_range=(1,2))
    X = vectorizer.fit_transform(df['clean'])
    y = df['label_num'].values
    print("\nTF-IDF matrix shape:", X.shape)

    # 6) Train/test split
    Xtr, Xte, ytr, yte = train_test_split(X, y, test_size=0.2, random_state=RANDOM_SEED, stratify=y)
    print("Train/test split:", Xtr.shape, Xte.shape)

    # 7) Train baseline classifier
    clf = LogisticRegression(max_iter=1000, solver='liblinear', random_state=RANDOM_SEED)
    print("Training Logistic Regression...")
    clf.fit(Xtr, ytr)

    # 8) Evaluate
    preds = clf.predict(Xte)
    print("\nClassification report (test):")
    print(classification_report(yte, preds, digits=4))
    cm = confusion_matrix(yte, preds)
    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=["ham","spam"])
    try:
        disp.plot()
        plt.title("Confusion Matrix")
        plt.tight_layout()
        plt.savefig("confusion_matrix.png", dpi=150)
        print("Saved confusion_matrix.png")
    except Exception as e:
        print("Plotting confusion matrix failed:", e)

    # 9) Save model & vectorizer
    joblib.dump(vectorizer, VECT_PATH)
    joblib.dump(clf, MODEL_PATH)
    print("Saved vectorizer ->", VECT_PATH)
    print("Saved model ->", MODEL_PATH)

    # 10) Simulated real-time loop (on test set) — 1 sample per second
    print("\nSimulated real-time predictions on 20 test samples (or fewer if test smaller):")
    n = min(20, Xte.shape[0])
    latencies = []
    sample_indices = np.random.RandomState(RANDOM_SEED).choice(np.arange(Xte.shape[0]), size=n, replace=False)
    for i, idx in enumerate(sample_indices):
        x = Xte[idx]
        start = time.time()
        p = clf.predict(x)
        latency = time.time() - start
        latencies.append(latency)
        label_true = yte[idx]
        print(f"Step {i+1:02d} — pred:{int(p[0])} true:{int(label_true)} latency:{latency*1000:.2f} ms")
        time.sleep(1.0)  # simulate 1-second arrival interval

    print("Average inference latency (ms):", np.mean(latencies)*1000)

    # 11) Small robustness experiment: add noise token to messages
    print("\nRobustness test: add random tokens to a few test messages")
    idxs = np.random.RandomState(RANDOM_SEED).choice(np.arange(len(df)), size=10, replace=False)
    for i, idx in enumerate(idxs):
        orig = df.iloc[idx]['clean']
        noisy = orig + " " + " ".join(["xyz"]*3)   # simple OOD token injection
        v = vectorizer.transform([noisy])
        p = clf.predict(v)[0]
        print(f"{i+1}. orig_len={len(orig.split())} -> pred:{p}")

    print("\n=== END ===")

if __name__ == "__main__":
    main()
