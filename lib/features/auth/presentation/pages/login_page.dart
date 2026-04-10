import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/auth/presentation/widgets/login_form.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (prev, curr) => curr is AuthSuccess || curr is AuthError,
        buildWhen: (prev, curr) => curr is! AuthSuccess,
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go(AppConstants.mainPage);
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              const LoginForm(),

              if (state is AuthLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: AppConstants.primaryColor,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
