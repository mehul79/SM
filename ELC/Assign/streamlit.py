# streamlit_app.py
"""
Simple Streamlit app for the SMS spam classifier
Run locally (NOT on Kaggle):
    streamlit run streamlit_app.py
"""

import streamlit as st
import joblib
import pandas as pd
import numpy as np
from pathlib import Path

MODEL_DIR = Path("models")
VECT_PATH = MODEL_DIR / "tfidf_vectorizer.joblib"
MODEL_PATH = MODEL_DIR / "text_lr.joblib"

st.set_page_config(page_title="SMS Spam Predictor", layout="centered")
st.title("SMS Spam Predictor (Logistic Regression)")

if not VECT_PATH.exists() or not MODEL_PATH.exists():
    st.error("Model or vectorizer not found. Run the training script first (all_in_one_pipeline.py).")
    st.stop()

vectorizer = joblib.load(VECT_PATH)
model = joblib.load(MODEL_PATH)

st.markdown("Paste an SMS message below and click Predict.")

msg = st.text_area("Message", value="Congratulations! You have won a free voucher. Reply YES to claim.")
col1, col2 = st.columns(2)
with col1:
    if st.button("Predict"):
        x = vectorizer.transform([msg])
        pred = model.predict(x)[0]
        prob = model.predict_proba(x).max()
        label = "SPAM" if pred==1 else "HAM"
        st.success(f"Prediction: {label}  (prob: {prob:.3f})")

with col2:
    if st.button("Random sample"):
        # load raw dataset for random sample if present
        try:
            df = pd.read_csv("data/SMSSpamCollection", sep='\t', header=None, names=['label','text'], quoting=3)
            row = df.sample(1).iloc[0]
            st.write("Label (true):", row.label)
            st.write("Text:", row.text)
        except Exception as e:
            st.warning("Dataset not found locally. Run the training script to download it.")

st.markdown("---")
st.write("Notes: This app is intended for a local demo. Kaggle does not allow serving Streamlit apps from its kernels.")
