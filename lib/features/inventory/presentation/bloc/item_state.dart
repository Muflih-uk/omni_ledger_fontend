import 'package:omni_ledger/features/inventory/domain/entities/item.dart';

abstract class ItemState {}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<Item> items;
  final List<Item> filterItems;

  ItemLoaded({required this.items, required this.filterItems});
}

class ItemError extends ItemState {
  final String message;
  ItemError(this.message);
}

class ItemCreated extends ItemState {}
