import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/auth/bloc/user_bloc.dart';
import 'package:kevin/modules/auth/data/model/user_model.dart';
import 'package:kevin/ui/widgets/app_form.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../services/app_functions.dart';
import '../../../services/app_preferences.dart';
import '../../../services/dependency_injection.dart';
import '../../../ui/widgets/app_loading_indicator.dart';
import '../../../ui/widgets/app_toast_messages.dart';
import '../../../ui/widgets/buttons/app_icon_button.dart';
import '../../../ui/widgets/texts/app_text_field.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late UserModel userModel;

  @override
  void initState() {
    userModel = appPreferences.getUser();
    _nameController.text = userModel.userName ?? "";
    _emailController.text = userModel.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _body(),
      appBar: _appBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(userModel.userName ?? userModel.email),
      actions: [
        BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UpdateUserSuccessState) {
              AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastState.success);
            } else if (state is UserFailureState) {
              AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
            }
          },
          builder: (context, state) {
            if (state is UserLoadingState) {
              return const AppLoadingIndicator();
            } else {
              return AppIconButton(
                iconButtonType: IconButtonType.save,
                onPress: () {
                  if (_formKey.currentState!.validate()) {
                    userModel = UserModel(
                      userModel.id,
                      _emailController.text.trim(),
                      _nameController.text.trim(),
                      userModel.created,
                      DateTime.now(),
                    );
                    BlocProvider.of<UserBloc>(context).add(UpdateUserEvent(userModel: userModel));
                    setState(() {
                      appPreferences.setUser(userModel);
                    });
                  }
                },
              );
            }
          },
        ),
      ],
    );
  }

  Widget _body() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _form(context),
        const SizedBox(height: 20),
        _otherInfo(),
      ],
    );
  }

  Widget _form(BuildContext context) {
    return AppForm(
      formKey: _formKey,
      content: <Widget>[
        AppTextField(
          controller: _nameController,
          label: AppLocalizations.of(context)!.name,
          isRequired: true,
          inputType: InputType.title,
        ),
        AppTextField(
          controller: _emailController,
          label: AppLocalizations.of(context)!.email,
          inputType: InputType.email,
        ),
      ],
    );
  }

  Widget _otherInfo() {
    return Table(
      children: [
        TableRow(children: [
          TableCell(child: Text(AppLocalizations.of(context)!.created)),
          TableCell(child: Text(appFormatDateTime(userModel.created, dateOnly: true))),
        ]),
        TableRow(children: [
          TableCell(child: Text(AppLocalizations.of(context)!.updated)),
          TableCell(child: Text(appFormatDateTime(userModel.updated, dateOnly: true))),
        ]),
      ],
    );
  }
}
