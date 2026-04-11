import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/features/bill/domain/usecases/bill_usecases.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_event.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_state.dart';

class BillingBloc extends Bloc<BillingEvent, BillingState> {
  final BillUsecases billUsecases;

  BillingBloc(this.billUsecases) : super(BillingState.initial()) {
    on<AddItemEvent>((event, emit) {
      final exists = state.selectedItems.any(
        (e) => e["item_id"] == event.item.id,
      );

      if (exists) return;

      final updated = List<Map<String, dynamic>>.from(state.selectedItems)
        ..add({
          "item_id": event.item.id,
          "name": event.item.name,
          "price": event.item.unitPrice,
          "quantity": 1,
        });

      emit(state.copyWith(selectedItems: updated));
    });

    on<RemoveItemEvent>((event, emit) {
      final updated = state.selectedItems
          .where((e) => e["item_id"] != event.itemId)
          .toList();

      emit(state.copyWith(selectedItems: updated));
    });

    on<UpdateQuantityEvent>((event, emit) {
      final updated = state.selectedItems.map((item) {
        if (item["item_id"] == event.itemId) {
          return {...item, "quantity": event.quantity};
        }
        return item;
      }).toList();

      emit(state.copyWith(selectedItems: updated));
    });

    on<TogglePaymentEvent>((event, emit) {
      emit(state.copyWith(isPaid: event.isPaid));
    });

    on<CreateBillEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final data = {
          "customer_name": event.name,
          "customer_phone": event.phone,
          "payment_status": state.isPaid ? "paid" : "unpaid",
          "items": state.selectedItems
              .map((e) => {"item_id": e["item_id"], "quantity": e["quantity"]})
              .toList(),
        };

        await billUsecases.call(data);

        emit(BillingState.initial());
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "Failed to create bill"));
      }
    });
  }
}
