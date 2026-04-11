import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/features/bill/domain/usecases/bill_usecases.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_event.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final BillUsecases billUsecases;

  HistoryBloc(this.billUsecases) : super(HistoryState.initial()) {
    on<ChangeTabEvent>((event, emit) async {
      emit(state.copyWith(currentTab: event.status, isLoading: true));

      add(FetchBillsEvent(event.status));
    });

    on<FetchBillsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final bills = await billUsecases.getBills(event.status);

        emit(state.copyWith(bills: bills, isLoading: false));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "Failed to load bills"));
      }
    });
  }
}
