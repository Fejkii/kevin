import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/const/app_values.dart';
import 'package:kevin/modules/auth/data/model/user_model.dart';
import 'package:kevin/modules/project/bloc/project_bloc.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/widgets/buttons/app_button.dart';
import 'package:kevin/ui/widgets/texts/app_subtitle_text.dart';
import 'package:kevin/ui/widgets/texts/app_text_field.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';

import '../bloc/user_project_bloc.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({Key? key}) : super(key: key);

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late UserModel userModel;
  late bool _isDefaultValue = false;
  late bool hasUserProject;

  @override
  void initState() {
    userModel = instance<AppPreferences>().getUser();
    hasUserProject = instance<AppPreferences>().hasUserProject();
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _getData() {
    BlocProvider.of<UserProjectBloc>(context).add(UserProjectListByUserEvent(userModel: appPreferences.getUser()));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProjectBloc, ProjectState>(listener: (context, state) {}),
      ],
      child: AppScaffold(
        body: _bodyWidget(),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: (() {
                appPreferences.logout();
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signin, (route) => false);
              }),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        AppTitleText(
          text: AppLocalizations.of(context)!.welcome(userModel.userName ?? userModel.email),
        ),
        const SizedBox(height: 20),
        AppSubTitleText(text: hasUserProject ? AppLocalizations.of(context)!.nextProject : AppLocalizations.of(context)!.noProject),
        const SizedBox(height: 20),
        _form(context),
        const Divider(height: 40),
        AppButton(
          title: AppLocalizations.of(context)!.showUserProjectList,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.projectList);
          },
        ),
      ],
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppTextField(
            controller: _titleController,
            label: AppLocalizations.of(context)!.projectName,
            isRequired: true,
            inputType: InputType.title,
            icon: Icons.tag,
          ),
          if (hasUserProject)
            Column(
              children: [
                const SizedBox(height: 20),
                CheckboxListTile(
                  title: Text(AppLocalizations.of(context)!.setProjectDefault),
                  subtitle: Text(AppLocalizations.of(context)!.isProjectDefaultSubtitle),
                  value: _isDefaultValue,
                  onChanged: (newValue) {
                    setState(() {
                      _isDefaultValue = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
              ],
            ),
          const SizedBox(height: 20),
          BlocConsumer<ProjectBloc, ProjectState>(
            listener: (context, state) {
              if (state is ProjectSuccessState) {
                setState(() {
                  _titleController.text = AppConstant.EMPTY;
                  _isDefaultValue = false;
                });
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
              } else if (state is ProjectFailureState) {
                AppToastMessage().showToastMsg(
                  state.errorMessage,
                  ToastState.error,
                );
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signin, (route) => false);
              }
            },
            builder: (context, state) {
              if (state is ProjectLoadingState) {
                return const AppLoadingIndicator();
              } else {
                return AppButton(
                  title: AppLocalizations.of(context)!.createProject,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<ProjectBloc>(context).add(CreateProjectEvent(title: _titleController.text.trim(), isDefault: _isDefaultValue));
                    }
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
