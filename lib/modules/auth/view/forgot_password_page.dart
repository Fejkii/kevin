import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/widgets/buttons/app_button.dart';
import 'package:kevin/ui/widgets/texts/app_subtitle_text.dart';
import 'package:kevin/ui/widgets/texts/app_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/auth_bloc.dart';

class ForgottenPasswordPage extends StatefulWidget {
  const ForgottenPasswordPage({super.key});

  @override
  State<ForgottenPasswordPage> createState() => _ForgottenPasswordPageState();
}

class _ForgottenPasswordPageState extends State<ForgottenPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _form(context),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.forgottenPasswordTitle),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppSubTitleText(text: AppLocalizations.of(context)!.forgottenPasswordInfo),
          const SizedBox(height: 40),
          AppTextField(
            controller: _emailController,
            label: AppLocalizations.of(context)!.email,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
            inputType: InputType.email,
          ),
          const SizedBox(height: 20),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is ForgotPasswordSendSuccessState) {
                AppToastMessage().showToastMsg(AppLocalizations.of(context)!.forgottenPasswordMessage, ToastState.success);
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signin, (route) => false);
              } else if (state is AuthFailureState) {
                AppToastMessage().showToastMsg(AppLocalizations.of(context)!.forgottenPasswordError, ToastState.error);
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const AppLoadingIndicator();
              } else {
                return AppButton(
                  title: AppLocalizations.of(context)!.resetPassword,
                  onTap: () {
                    _formKey.currentState!.validate()
                        ? BlocProvider.of<AuthBloc>(context).add(ForgotPasswordEvent(email: _emailController.text.trim()))
                        : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.forgottenPasswordError, ToastState.error);
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}
