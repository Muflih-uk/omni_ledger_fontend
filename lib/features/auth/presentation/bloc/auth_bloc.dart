import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;

  AuthBloc(this.loginUsecase) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        await loginUsecase(event.phone, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError('Login failed'));
      }
    });
  }
}
