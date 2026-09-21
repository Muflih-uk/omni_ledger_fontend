import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/core/exceptions/api_exception.dart';
import 'package:omni_ledger/features/bill/domain/usecases/bill_usecases.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_event.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_state.dart';

class BillingBloc extends Bloc<BillingEvent, BillingState> {
  final BillUsecases billUsecases;

  BillingBloc(this.billUsecases) : super(BillingState.initial()) {
    on<AddItemEvent>((event, emit) {
      final quantity = _clampQuantity(event.quantity);
      final index = state.selectedItems.indexWhere(
        (e) => e["item_id"] == event.item.id,
      );

      final updated = List<Map<String, dynamic>>.from(state.selectedItems);

      if (index >= 0) {
        updated[index] = {...updated[index], "quantity": quantity};
      } else {
        updated.add({
          "item_id": event.item.id,
          "name": event.item.name,
          "price": event.item.unitPrice,
          "quantity": quantity,
        });
      }

      emit(state.copyWith(selectedItems: updated));
    });

    on<RemoveItemEvent>((event, emit) {
      final updated = state.selectedItems
          .where((e) => e["item_id"] != event.itemId)
          .toList();

      emit(state.copyWith(selectedItems: updated));
    });

    on<UpdateQuantityEvent>((event, emit) {
      final quantity = _clampQuantity(event.quantity);

      final updated = state.selectedItems.map((item) {
        if (item["item_id"] == event.itemId) {
          return {...item, "quantity": quantity};
        }
        return item;
      }).toList();

      emit(state.copyWith(selectedItems: updated));
    });

    on<UpdateItemPriceEvent>((event, emit) {
      final price = event.price < 0 ? 0.0 : event.price;

      final updated = state.selectedItems.map((item) {
        if (item["item_id"] == event.itemId) {
          return {...item, "price": price};
        }
        return item;
      }).toList();

      emit(state.copyWith(selectedItems: updated));
    });

    on<UpdateItemNameEvent>((event, emit) {
      final name = event.name.trim().isEmpty ? "Item" : event.name.trim();

      final updated = state.selectedItems.map((item) {
        if (item["item_id"] == event.itemId) {
          return {...item, "name": name};
        }
        return item;
      }).toList();

      emit(state.copyWith(selectedItems: updated));
    });

    on<TogglePaymentEvent>((event, emit) {
      emit(state.copyWith(isPaid: event.isPaid));
    });

    on<SetBillingStepEvent>((event, emit) {
      emit(state.copyWith(step: event.step.clamp(0, 2).toInt()));
    });

    on<ClearCartEvent>((event, emit) {
      emit(state.copyWith(selectedItems: const []));
    });

    on<CreateBillEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, clearError: true));

      try {
        final data = {
          "customer_name": event.name,
          "customer_phone": event.phone,
          "payment_status": state.isPaid ? "paid" : "unpaid",
          "items": state.selectedItems
              .map(
                (e) => {
                  "item_id": e["item_id"],
                  "name": e["name"],
                  "price": BillingState.asDouble(e["price"]),
                  "quantity": BillingState.asInt(e["quantity"]),
                },
              )
              .toList(),
        };

        final bill = await billUsecases.create(data);

        emit(
          BillingState.initial().copyWith(
            isLoading: false,
            createdBill: bill,
          ),
        );
      } catch (e) {
        final message = e is ApiException ? e.message : "Failed to create bill";
        emit(state.copyWith(isLoading: false, error: message));
      }
    });
  }

  int _clampQuantity(int quantity) => quantity < 1 ? 1 : quantity;
}