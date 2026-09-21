import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/core/exceptions/api_exception.dart';
import 'package:omni_ledger/features/auth/domain/repositories/auth_repository.dart';
import 'package:omni_ledger/features/splash/domain/usecases/check_server_usecase.dart';
import 'package:omni_ledger/features/splash/presentation/bloc/splash_event.dart';
import 'package:omni_ledger/features/splash/presentation/bloc/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckServerUsecase checkServerUsecase;
  final AuthRepository authRepository;

  SplashBloc(this.checkServerUsecase, this.authRepository)
    : super(SplashInitial()) {
    on<CheckServerEvent>((event, emit) async {
      emit(SplashLoading());

      try {
        await checkServerUsecase.call();
        emit(SplashLoaded(authRepository.isLoggedIn()));
      } catch (e) {
        final message = e is ApiException ? e.message : "Connection failed";
        emit(SplashError(message));
      }
    });
  }
}