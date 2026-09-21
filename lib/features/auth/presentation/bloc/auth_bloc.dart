import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/core/exceptions/api_exception.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;

  AuthBloc(this.loginUsecase, this.registerUsecase) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        await loginUsecase(event.phone, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(_message(e, "Login failed")));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        await registerUsecase(event.name, event.phone, event.password);
        emit(AuthRegisterSuccess());
      } catch (e) {
        emit(AuthError(_message(e, "Registration failed")));
      }
    });
  }

  String _message(Object e, String fallback) {
    return e is ApiException ? e.message : fallback;
  }
}