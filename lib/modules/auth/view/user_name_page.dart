import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/ui/widgets/texts/app_subtitle_text.dart';

import '../../../const/app_routes.dart';
import '../../../services/app_preferences.dart';
import '../../../services/dependency_injection.dart';
import '../../../ui/widgets/app_loading_indicator.dart';
import '../../../ui/widgets/app_scaffold.dart';
import '../../../ui/widgets/app_toast_messages.dart';
import '../../../ui/widgets/buttons/app_button.dart';
import '../../../ui/widgets/texts/app_text_field.dart';
import '../bloc/user_bloc.dart';

class UserNamePage extends StatefulWidget {
  const UserNamePage({super.key});

  @override
  State<UserNamePage> createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
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
          AppSubTitleText(text: AppLocalizations.of(context)!.noName),
          const SizedBox(height: 40),
          AppTextField(
            controller: _nameController,
            label: AppLocalizations.of(context)!.email,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
            inputType: InputType.email,
          ),
          const SizedBox(height: 20),
          BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserNameSuccessState) {
                if (!appPreferences.hasUserProject()) {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.createProject, (route) => false);
                } else {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                }
              } else if (state is UserFailureState) {
                AppToastMessage().showToastMsg(AppLocalizations.of(context)!.nameError, ToastState.error);
              }
            },
            builder: (context, state) {
              if (state is UserLoadingState) {
                return const AppLoadingIndicator();
              } else {
                return AppButton(
                  title: AppLocalizations.of(context)!.setName,
                  onTap: () {
                    _formKey.currentState!.validate()
                        ? BlocProvider.of<UserBloc>(context)
                            .add(UserNameEvent(userModel: appPreferences.getUser(), name: _nameController.text.trim()))
                        : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.nameError, ToastState.error);
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
