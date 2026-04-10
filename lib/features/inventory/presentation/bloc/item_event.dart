abstract class ItemEvent {}

class FetchItemEvent extends ItemEvent {}

class SearchItemEvent extends ItemEvent {
  final String query;
  SearchItemEvent(this.query);
}

class CreateItemEvent extends ItemEvent {
  final String name;
  final double unitPrice;
  CreateItemEvent({required this.name, required this.unitPrice});
}
