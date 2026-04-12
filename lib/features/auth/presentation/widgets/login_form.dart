import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/core/util/validator.dart';
import 'package:omni_ledger/shared/ui/app_text_button.dart';
import 'package:omni_ledger/shared/ui/app_text_form_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppConstants.screenPadding,
      decoration: BoxDecoration(gradient: AppConstants.loginGradient),
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                "Omni Ledger",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        "Welcome",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Please enter your details to sign in",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phone Number",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          AppTextFormField(
                            controller: phoneController,
                            hintText: "00000 00000",
                            keyboardType: TextInputType.number,
                            validator: Validators.phone,
                          ),

                          SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Password",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              Text(
                                "Forgot Password ?",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                          AppTextFormField(
                            controller: passwordController,
                            hintText: "*************",
                            keyboardType: TextInputType.text,
                            validator: Validators.password,
                            obscureText: true,
                          ),

                          SizedBox(height: 30),
                          AppTextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  LoginEvent(
                                    phoneController.text.trim(),
                                    passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                            text: "Login",
                          ),
                        ],
                      ),
                      SizedBox(height: 60),
                      Container(
                        decoration: BoxDecoration(
                          color: AppConstants.containerColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "New Store Owner",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  "Contact admin for account setup.",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.report_gmailerrorred,
                              color: AppConstants.secondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
