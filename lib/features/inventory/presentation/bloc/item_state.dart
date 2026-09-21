import 'package:omni_ledger/features/inventory/domain/entities/item.dart';

abstract class ItemState {}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<Item> items;
  final List<Item> filterItems;
  final Set<int> deletingIds;

  ItemLoaded({
    required this.items,
    required this.filterItems,
    this.deletingIds = const {},
  });

  ItemLoaded copyWith({
    List<Item>? items,
    List<Item>? filterItems,
    Set<int>? deletingIds,
  }) {
    return ItemLoaded(
      items: items ?? this.items,
      filterItems: filterItems ?? this.filterItems,
      deletingIds: deletingIds ?? this.deletingIds,
    );
  }
}

class ItemError extends ItemState {
  final String message;
  final List<Item>? items;
  final List<Item>? filterItems;

  ItemError(this.message, {this.items, this.filterItems});
}

class ItemCreated extends ItemState {}

class ItemUpdated extends ItemState {}

class ItemDeleted extends ItemState {}