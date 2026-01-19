function calculateDiscount(purchaseAmount) {
    if (purchaseAmount < 0 && typeof(purchaseAmount) == Number) {
        return "Invalid amount";
    }

    let discount = 0;

    if (purchaseAmount >= 9999) {
        discount = 50;
    } else if (purchaseAmount >= 7999) {
        discount = 35;
    } else if (purchaseAmount >= 5999) {
        discount = 25;
    } else if (purchaseAmount >= 3999) {
        discount = 15;
    } else if (purchaseAmount >= 1999) {
        discount = 10;
    } else if (purchaseAmount >= 999) {
        discount = 5;
    }

    return discount;
}

const test_cases = [
  { input: 10000, expected: 50 },
  { input: 8000, expected: 35 },
  { input: 6000, expected: 25 },
  { input: 4000, expected: 15 },
  { input: 2000, expected: 10 },
  { input: 1000, expected: 5 },
  { input: 500, expected: 0 },
  { input: -1000, expected: "Invalid amount" },
  {input: "-abc", expected: "Invalid amount"}
]


test_cases.forEach((test, index) => {
    const result = calculateDiscount(test.input);
    console.log(
        `Test Case ${index + 1}: Amount = ${test.input}, ` +
        `Expected = ${test.expected}, Actual = ${result}`
    );
});


