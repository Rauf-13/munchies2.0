/// Nigerian Naira display with thousands separators (e.g. ₦7,700).
String formatNaira(double value) {
  final digits = value.round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buf.write(',');
    }
    buf.write(digits[i]);
  }
  return '₦$buf';
}

