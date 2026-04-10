abstract class ItemEvent {}

class FetchItemEvent extends ItemEvent {}

class SearchItemEvent extends ItemEvent {
  final String query;
  SearchItemEvent(this.query);
}
