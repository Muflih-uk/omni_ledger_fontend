import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/auth/domain/repositories/auth_repository.dart';
import 'package:omni_ledger/features/auth/presentation/pages/login_page.dart';
import 'package:omni_ledger/features/auth/presentation/pages/register_page.dart';
import 'package:omni_ledger/features/bill/domain/entities/bill.dart';
import 'package:omni_ledger/features/bill/presentation/pages/invoice_page.dart';
import 'package:omni_ledger/features/inventory/domain/entities/item.dart';
import 'package:omni_ledger/features/inventory/presentation/pages/item_form_page.dart';
import 'package:omni_ledger/features/main/presentation/pages/main_page.dart';
import 'package:omni_ledger/features/splash/presentation/pages/splash_page.dart';
import 'package:omni_ledger/injection_container.dart';

final router = GoRouter(
  initialLocation: AppConstants.splashPage,
  redirect: (context, state) {
    final authRepo = sl<AuthRepository>();
    final isLoggedIn = authRepo.isLoggedIn();

    final isAuthPage =
        state.fullPath == AppConstants.login ||
        state.fullPath == AppConstants.register ||
        state.fullPath == AppConstants.splashPage;

    if (!isLoggedIn && !isAuthPage) return AppConstants.login;
    if (isLoggedIn && state.fullPath == AppConstants.login) {
      return AppConstants.mainPage;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppConstants.splashPage,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppConstants.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppConstants.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppConstants.mainPage,
      builder: (context, state) {
        final tab = state.uri.queryParameters['tab'];
        final index = switch (tab) {
          'inventory' => 3,
          _ => 0,
        };
        return MainPage(initialIndex: index);
      },
    ),
    GoRoute(
      path: AppConstants.additemPage,
      builder: (context, state) => const ItemFormPage(),
    ),
    GoRoute(
      path: AppConstants.edititemPage,
      builder: (context, state) {
        final item = state.extra is Item ? state.extra as Item : null;
        return ItemFormPage(item: item);
      },
    ),
    GoRoute(
      path: AppConstants.invoicePage,
      builder: (context, state) {
        final bill = state.extra is Bill ? state.extra as Bill : null;
        return InvoicePage(bill: bill);
      },
    ),
  ],
);