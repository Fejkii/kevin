import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/bloc/auth/auth_bloc.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/widgets/buttons/app_button.dart';
import 'package:kevin/ui/widgets/texts/app_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _registerForm(context),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.registration),
      ),
    );
  }

  Widget _registerForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          AppTextField(
            controller: _nameController,
            label: AppLocalizations.of(context)!.name,
            isRequired: true,
            icon: Icons.text_fields_outlined,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _emailController,
            label: AppLocalizations.of(context)!.email,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
            inputType: InputType.email,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _passwordController,
            label: AppLocalizations.of(context)!.password,
            isRequired: true,
            inputType: InputType.password,
          ),
          const SizedBox(height: 20),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is LoggedInState) {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
              } else if (state is AuthFailureState) {
                AppToastMessage().showToastMsg(AppLocalizations.of(context)!.loginError, ToastState.error);
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const AppLoadingIndicator();
              } else {
                return AppButton(
                  title: AppLocalizations.of(context)!.register,
                  onTap: () {
                    _formKey.currentState!.validate()
                        ? BlocProvider.of<AuthBloc>(context).add(RegisterEvent(
                            userName: _nameController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          ))
                        : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.loginError, ToastState.error);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
