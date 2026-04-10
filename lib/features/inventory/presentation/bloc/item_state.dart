abstract class ItemState {}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List items;
  final List filterItems;

  ItemLoaded({required this.items, required this.filterItems});
}

class ItemError extends ItemState {
  final String message;
  ItemError(this.message);
}
