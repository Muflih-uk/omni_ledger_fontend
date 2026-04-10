import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/auth/domain/repositories/auth_repository.dart';
import 'package:omni_ledger/features/auth/presentation/pages/login_page.dart';
import 'package:omni_ledger/features/main/presentation/pages/main_page.dart';
import 'package:omni_ledger/injection_container.dart';
import 'package:omni_ledger/features/inventory/presentation/pages/create_item_page.dart';

final router = GoRouter(
  initialLocation: AppConstants.mainPage,
  redirect: (context, state) {
    final authRepo = sl<AuthRepository>();
    final isLoggedIn = authRepo.isLoggedIn();

    final isLoginPage = state.fullPath == AppConstants.login;

    if (!isLoggedIn && !isLoginPage) return AppConstants.login;
    if (isLoggedIn && isLoginPage) return AppConstants.mainPage;

    return null;
  },
  routes: [
    GoRoute(
      path: AppConstants.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppConstants.mainPage,
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: AppConstants.additemPage,
      builder: (context, state) => const CreateItemPage(),
    ),
    // GoRoute(
    //   path: '/home',
    //   builder: (context, state) => const HistoryPage(), // temp home
    // ),
  ],
);
