abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  final bool isLoggedIn;
  SplashLoaded(this.isLoggedIn);
}

class SplashError extends SplashState {
  final String message;
  SplashError(this.message);
}