import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/features/main/presentation/bloc/event.dart';
import 'package:omni_ledger/features/main/presentation/bloc/state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(currentIndex: 0)) {
    on<MainChangeTabEvent>((event, emit) {
      emit(NavigationState(currentIndex: event.index));
    });
  }
}
