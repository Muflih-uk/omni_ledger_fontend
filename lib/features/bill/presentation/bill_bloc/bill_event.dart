abstract class BillingEvent {}

class AddItemEvent extends BillingEvent {
  final dynamic item;
  AddItemEvent(this.item);
}

class RemoveItemEvent extends BillingEvent {
  final int itemId;
  RemoveItemEvent(this.itemId);
}

class UpdateQuantityEvent extends BillingEvent {
  final int itemId;
  final int quantity;
  UpdateQuantityEvent(this.itemId, this.quantity);
}

class TogglePaymentEvent extends BillingEvent {
  final bool isPaid;
  TogglePaymentEvent(this.isPaid);
}

class CreateBillEvent extends BillingEvent {
  final String name;
  final String phone;

  CreateBillEvent({required this.name, required this.phone});
}
