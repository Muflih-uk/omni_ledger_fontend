abstract class HistoryEvent {}

class FetchBillsEvent extends HistoryEvent {
  final String status;
  FetchBillsEvent(this.status);
}

class ChangeTabEvent extends HistoryEvent {
  final String status;
  ChangeTabEvent(this.status);
}
