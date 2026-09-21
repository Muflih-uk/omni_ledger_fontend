String formatPrice(double value) {
  if (value == value.roundToDouble()) {
    return "₹${value.toStringAsFixed(0)}";
  }
  return "₹${value.toStringAsFixed(2)}";
}