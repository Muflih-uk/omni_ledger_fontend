import 'package:omni_ledger/features/inventory/domain/entities/item.dart';

abstract class BillingEvent {}

class AddItemEvent extends BillingEvent {
  final Item item;
  final int quantity;

  AddItemEvent(this.item, {this.quantity = 1});
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

class UpdateItemPriceEvent extends BillingEvent {
  final int itemId;
  final double price;
  UpdateItemPriceEvent(this.itemId, this.price);
}

class UpdateItemNameEvent extends BillingEvent {
  final int itemId;
  final String name;
  UpdateItemNameEvent(this.itemId, this.name);
}

class TogglePaymentEvent extends BillingEvent {
  final bool isPaid;
  TogglePaymentEvent(this.isPaid);
}

class SetBillingStepEvent extends BillingEvent {
  final int step;
  SetBillingStepEvent(this.step);
}

class CreateBillEvent extends BillingEvent {
  final String name;
  final String phone;

  CreateBillEvent({required this.name, required this.phone});
}

class ClearCartEvent extends BillingEvent {}