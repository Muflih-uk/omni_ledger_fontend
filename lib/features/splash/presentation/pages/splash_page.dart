import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/shared/ui/app_text_button.dart';
import 'package:omni_ledger/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:omni_ledger/features/splash/presentation/bloc/splash_event.dart';
import 'package:omni_ledger/features/splash/presentation/bloc/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    context.read<SplashBloc>().add(CheckServerEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppConstants.loginGradient),
      child: Scaffold(
        body: BlocConsumer<SplashBloc, SplashState>(
          listenWhen: (prev, curr) => curr is SplashLoaded,
          listener: (context, state) {
            if (state is SplashLoaded) {
              context.go(
                state.isLoggedIn
                    ? AppConstants.mainPage
                    : AppConstants.login,
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: Tween(begin: 0.92, end: 1.04).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.primaryColor.withValues(alpha: 0.25),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(18),
                        child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Omni Ledger",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Preparing your retail workspace",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 50),
                    if (state is SplashError) _buildError(context, state) else _buildLoading(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Column(
      children: [
        SizedBox(
          width: 34,
          height: 34,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: AppConstants.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, SplashError state) {
    return Column(
      children: [
        Text(
          "Cannot reach the server",
          style: Theme.of(context).textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          state.message,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        AppTextButton(
          text: "Retry",
          backgroundColor: AppConstants.primaryColor,
          onPressed: () {
            context.read<SplashBloc>().add(CheckServerEvent());
          },
        ),
      ],
    );
  }
}