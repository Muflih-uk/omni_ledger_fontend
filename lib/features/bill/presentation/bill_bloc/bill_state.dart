import 'package:equatable/equatable.dart';
import 'package:omni_ledger/features/bill/domain/entities/bill.dart';

class BillingState extends Equatable {
  final List<Map<String, dynamic>> selectedItems;
  final bool isPaid;
  final bool isLoading;
  final int step;
  final String? error;
  final Bill? createdBill;

  const BillingState({
    required this.selectedItems,
    required this.isPaid,
    required this.isLoading,
    required this.step,
    this.error,
    this.createdBill,
  });

  int get itemCount => selectedItems.fold(
    0,
    (sum, item) => sum + asInt(item["quantity"]),
  );

  double get total => selectedItems.fold(
    0.0,
    (sum, item) => sum + asInt(item["quantity"]) * asDouble(item["price"]),
  );

  static int asInt(Object? value) => value is num ? value.toInt() : 0;

  static double asDouble(Object? value) =>
      value is num ? value.toDouble() : 0.0;

  factory BillingState.initial() {
    return const BillingState(
      selectedItems: [],
      isPaid: false,
      isLoading: false,
      step: 0,
    );
  }

  BillingState copyWith({
    List<Map<String, dynamic>>? selectedItems,
    bool? isPaid,
    bool? isLoading,
    int? step,
    String? error,
    bool clearError = false,
    Bill? createdBill,
  }) {
    return BillingState(
      selectedItems: selectedItems ?? this.selectedItems,
      isPaid: isPaid ?? this.isPaid,
      isLoading: isLoading ?? this.isLoading,
      step: step ?? this.step,
      error: clearError ? null : error ?? this.error,
      createdBill: createdBill,
    );
  }

  @override
  List<Object?> get props => [
    selectedItems,
    isPaid,
    isLoading,
    step,
    error,
    createdBill,
  ];
}