import 'package:equatable/equatable.dart';
import 'package:omni_ledger/features/bill/domain/entities/bill.dart';

class HistoryState extends Equatable {
  final List<Bill> bills;
  final String currentTab;
  final bool isLoading;
  final String? error;
  final Set<int> togglingIds;

  const HistoryState({
    required this.bills,
    required this.currentTab,
    required this.isLoading,
    this.error,
    this.togglingIds = const {},
  });

  factory HistoryState.initial() {
    return const HistoryState(bills: [], currentTab: "paid", isLoading: false);
  }

  List<Bill> get filteredBills =>
      bills.where((b) => b.paymentStatus == currentTab).toList();

  int get paidCount => bills.where((b) => b.paymentStatus == "paid").length;

  int get unpaidCount => bills.where((b) => b.paymentStatus == "unpaid").length;

  HistoryState copyWith({
    List<Bill>? bills,
    String? currentTab,
    bool? isLoading,
    String? error,
    Set<int>? togglingIds,
  }) {
    return HistoryState(
      bills: bills ?? this.bills,
      currentTab: currentTab ?? this.currentTab,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      togglingIds: togglingIds ?? this.togglingIds,
    );
  }

  @override
  List<Object?> get props => [
    bills,
    currentTab,
    isLoading,
    error,
    togglingIds,
  ];
}