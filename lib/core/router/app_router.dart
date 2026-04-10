import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/auth/domain/repositories/auth_repository.dart';
import 'package:omni_ledger/features/auth/presentation/pages/login_page.dart';
import 'package:omni_ledger/injection_container.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final authRepo = sl<AuthRepository>();
    final isLoggedIn = authRepo.isLoggedIn();

    final isLoginPage = state.fullPath == '/';

    if (!isLoggedIn && !isLoginPage) return '/';
    if (isLoggedIn && isLoginPage) return '/home';

    return null;
  },
  routes: [
    GoRoute(
      path: AppConstants.mainPage,
      builder: (context, state) => const LoginPage(),
    ),
    // GoRoute(
    //   path: '/home',
    //   builder: (context, state) => const HistoryPage(), // temp home
    // ),
  ],
);
