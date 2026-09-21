import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/core/util/validator.dart';
import 'package:omni_ledger/shared/ui/app_text_button.dart';
import 'package:omni_ledger/shared/ui/app_text_form_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
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
                        "Create Account",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Please enter your details to sign up",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          AppTextFormField(
                            controller: nameController,
                            hintText: "Enter your name",
                            keyboardType: TextInputType.text,
                            validator: Validators.name,
                          ),

                          SizedBox(height: 20),

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

                          Text(
                            "Password",
                            style: Theme.of(context).textTheme.labelLarge,
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
                                  RegisterEvent(
                                    name: nameController.text.trim(),
                                    phone: phoneController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                            text: "Create Account",
                          ),
                        ],
                      ),
                      SizedBox(height: 60),
                      GestureDetector(
                        onTap: () {
                          context.go(AppConstants.login);
                        },
                        child: Container(
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
                                    "Already have an account",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    "Back to login",
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.login,
                                color: AppConstants.secondaryColor,
                              ),
                            ],
                          ),
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