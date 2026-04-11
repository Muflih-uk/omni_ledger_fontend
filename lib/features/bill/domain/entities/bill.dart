class Bill {
  final int id;
  final String customerName;
  final String customerPhone;
  final double totalAmount;
  final String paymentStatus;
  final DateTime createdAt;

  Bill({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.totalAmount,
    required this.paymentStatus,
    required this.createdAt,
  });
}
