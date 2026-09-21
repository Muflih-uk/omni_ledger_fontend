class BillItem {
  final int id;
  final int itemId;
  final String itemName;
  final int quantity;
  final double price;

  BillItem({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.price,
  });
}

class Bill {
  final int id;
  final String customerName;
  final String customerPhone;
  final double totalAmount;
  final String paymentStatus;
  final DateTime createdAt;
  final List<BillItem> items;

  Bill({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.totalAmount,
    required this.paymentStatus,
    required this.createdAt,
    this.items = const [],
  });

  Bill copyWithStatus(String status) {
    return Bill(
      id: id,
      customerName: customerName,
      customerPhone: customerPhone,
      totalAmount: totalAmount,
      paymentStatus: status,
      createdAt: createdAt,
      items: items,
    );
  }
}