import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/core/exceptions/api_exception.dart';
import 'package:omni_ledger/features/bill/domain/usecases/bill_usecases.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_event.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final BillUsecases billUsecases;

  HistoryBloc(this.billUsecases) : super(HistoryState.initial()) {
    on<FetchBillsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));

      try {
        final bills = await billUsecases.getBills();

        emit(state.copyWith(bills: bills, isLoading: false));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: e is ApiException ? e.message : "Failed to load bills",
          ),
        );
      }
    });

    on<ChangeTabEvent>((event, emit) {
      emit(state.copyWith(currentTab: event.status));

      if (state.bills.isEmpty && !state.isLoading) {
        add(FetchBillsEvent());
      }
    });

    on<ToggleBillStatusEvent>((event, emit) async {
      final index = state.bills.indexWhere((b) => b.id == event.billId);
      if (index == -1) return;

      final updated = [...state.bills];
      updated[index] = updated[index].copyWithStatus(
        updated[index].paymentStatus == "paid" ? "unpaid" : "paid",
      );

      emit(
        state.copyWith(
          bills: updated,
          togglingIds: {...state.togglingIds, event.billId},
        ),
      );

      try {
        await billUsecases.togglePaymentStatus(event.billId);
      } catch (e) {
        final reverted = [...state.bills];
        reverted[index] = reverted[index].copyWithStatus(
          reverted[index].paymentStatus == "paid" ? "unpaid" : "paid",
        );

        emit(
          state.copyWith(
            bills: reverted,
            error: "Could not update payment status",
          ),
        );
      } finally {
        emit(
          state.copyWith(
            togglingIds: state.togglingIds.difference({event.billId}),
          ),
        );
      }
    });
  }
}