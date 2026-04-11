import 'package:equatable/equatable.dart';

class HistoryState extends Equatable {
  final List bills;
  final String currentTab;
  final bool isLoading;
  final String? error;

  const HistoryState({
    required this.bills,
    required this.currentTab,
    required this.isLoading,
    this.error,
  });

  factory HistoryState.initial() {
    return const HistoryState(bills: [], currentTab: "paid", isLoading: false);
  }

  HistoryState copyWith({
    List? bills,
    String? currentTab,
    bool? isLoading,
    String? error,
  }) {
    return HistoryState(
      bills: bills ?? this.bills,
      currentTab: currentTab ?? this.currentTab,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [bills, currentTab, isLoading, error];
}
