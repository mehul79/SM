function check_triangle(side1, side2, side3) {
  if (side1 > 10 || side2 > 10 || side3 > 10) {
    return "Invalid Triangle";
  } else if (side1 == side2 && side2 == side3) {
    return "Equilateral Triangle";
  } else if (side1 == side2 || side2 == side3 || side1 == side3)
    return "Isosceles Triangle";
  else {
    return "Scalene Triangle";
  }
}


const testCases = [

    { a: 1, b: 1, c: 1, expected: "Equilateral Triangle" },
    { a: 1, b: 2, c: 2, expected: "Isosceles Triangle" },
    { a: 10, b: 10, c: 10, expected: "Equilateral Triangle" },
    { a: 10, b: 10, c: 9, expected: "Isosceles Triangle" },
    { a: 9, b: 10, c: 10, expected: "Isosceles Triangle" },
    { a: 8, b: 9, c: 10, expected: "Scalene Triangle" },
    { a: 2, b: 2, c: 3, expected: "Isosceles Triangle" },
    { a: 9, b: 9, c: 9, expected: "Equilateral Triangle" },
    { a: 9, b: 9, c: 10, expected: "Isosceles Triangle" },
    { a: 11, b: 12, c: 13, expected: "Invalid Triangle" },
    { a: 11, b: 1, c: 8, expected: "Invalid Triangle" },
];


// Run tests
testCases.forEach(testCase => {
    const result = check_triangle(testCase.a, testCase.b, testCase.c);
    console.log(`Test case ${testCase.a}, ${testCase.b}, ${testCase.c}: ${result === testCase.expected ? 'Passed' : 'Failed'}`);
});

