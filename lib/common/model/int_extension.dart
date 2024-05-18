extension TwoDigit on int {
  String digits(int numberOfDigits) => toString().padLeft(numberOfDigits, "0");
}
