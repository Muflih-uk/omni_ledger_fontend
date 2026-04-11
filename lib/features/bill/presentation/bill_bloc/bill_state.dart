import 'package:equatable/equatable.dart';

class BillingState extends Equatable {
  final List<Map<String, dynamic>> selectedItems;
  final bool isPaid;
  final bool isLoading;
  final String? error;

  const BillingState({
    required this.selectedItems,
    required this.isPaid,
    required this.isLoading,
    this.error,
  });

  factory BillingState.initial() {
    return const BillingState(
      selectedItems: [],
      isPaid: false,
      isLoading: false,
    );
  }

  BillingState copyWith({
    List<Map<String, dynamic>>? selectedItems,
    bool? isPaid,
    bool? isLoading,
    String? error,
  }) {
    return BillingState(
      selectedItems: selectedItems ?? this.selectedItems,
      isPaid: isPaid ?? this.isPaid,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedItems, isPaid, isLoading, error];
}
