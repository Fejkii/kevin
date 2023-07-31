import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/bloc/auth/auth_bloc.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/widgets/buttons/app_button.dart';
import 'package:kevin/ui/widgets/buttons/app_text_button.dart';
import 'package:kevin/ui/widgets/texts/app_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _emailController.text = "petr@test.cz"; // TODO delete
    _passwordController.text = "password";
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _loginForm(context),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                if (appPreferences.getUser().userName == null) {
                  // TODO Přesměrovat na create Name
                  if (kDebugMode) {
                    print("Error: User nemá jméno");
                  }
                } else if (appPreferences.getUserProject() == null) {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.createProject, (route) => false);
                } else {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                }
              } else if (state is AuthFailureState) {
                AppToastMessage().showToastMsg(AppLocalizations.of(context)!.loginError, ToastState.error);
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const AppLoadingIndicator();
              } else {
                return AppButton(
                  title: AppLocalizations.of(context)!.loginButton,
                  onTap: () {
                    _formKey.currentState!.validate()
                        ? BlocProvider.of<AuthBloc>(context).add(LogInEvent(email: _emailController.text.trim(), password: _passwordController.text.trim()))
                        : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.loginError, ToastState.error);
                  },
                );
              }
            },
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextButton(
                  title: AppLocalizations.of(context)!.register,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.register);
                  }),
              AppTextButton(
                  title: AppLocalizations.of(context)!.forgottenPassword,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.forgetPassword);
                  }),
            ],
          )
        ],
      ),
    );
  }
}
