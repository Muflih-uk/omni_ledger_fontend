abstract class HistoryEvent {}

class FetchBillsEvent extends HistoryEvent {}

class ChangeTabEvent extends HistoryEvent {
  final String status;
  ChangeTabEvent(this.status);
}

class ToggleBillStatusEvent extends HistoryEvent {
  final int billId;
  ToggleBillStatusEvent(this.billId);
}