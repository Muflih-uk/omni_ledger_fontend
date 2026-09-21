abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String phone;
  final String password;

  LoginEvent(this.phone, this.password);
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String phone;
  final String password;

  RegisterEvent({required this.name, required this.phone, required this.password});
}