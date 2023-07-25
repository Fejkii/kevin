import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/bloc/project/project_bloc.dart';
import 'package:kevin/bloc/user_project/user_project_bloc.dart';
import 'package:kevin/const/app_values.dart';
import 'package:kevin/models/project_model.dart';
import 'package:kevin/models/user_project_model.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/app_list_view.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_modal_dialog.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/widgets/buttons/app_button.dart';
import 'package:kevin/ui/widgets/texts/app_text_field.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';

class ShareProjectWidget extends StatefulWidget {
  const ShareProjectWidget({super.key});

  @override
  State<ShareProjectWidget> createState() => _ShareProjectWidgetState();
}

class _ShareProjectWidgetState extends State<ShareProjectWidget> {
  final TextEditingController _emailController = TextEditingController();
  final AppPreferences appPreferences = instance<AppPreferences>();
  final _formKey = GlobalKey<FormState>();
  late List<UserProjectModel> userList;
  late ProjectModel projectModel;

  @override
  void initState() {
    projectModel = appPreferences.getUserProject()!.project;
    _getData();
    userList = [];
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _getData() {
    BlocProvider.of<UserProjectBloc>(context).add(UserProjectListByProjectEvent(projectModel: projectModel));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                addUserToProject(context),
                const Divider(height: 40),
                _usersInProject(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget addUserToProject(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppTitleText(text: AppLocalizations.of(context)!.shareProject),
          const SizedBox(height: 20),
          AppTextField(
            controller: _emailController,
            label: AppLocalizations.of(context)!.email,
            keyboardType: TextInputType.emailAddress,
            inputType: InputType.email,
          ),
          const SizedBox(height: 20),
          BlocConsumer<ProjectBloc, ProjectState>(
            listener: (context, state) {
              if (state is ShareProjectSuccessState) {
                AppToastMessage().showToastMsg(AppLocalizations.of(context)!.createdSuccessfully, ToastState.success);
                setState(() {
                  _emailController.text = AppConstant.EMPTY;
                });
                _getData();
              } else if (state is DeleteUserProjectSuccessState) {
                AppToastMessage().showToastMsg(AppLocalizations.of(context)!.userProjectDeleted, ToastState.success);
                _getData();
              } else if (state is ShareProjectFailureState) {
                AppToastMessage().showToastMsg(AppLocalizations.of(context)!.emailIsNotRegistered, ToastState.error);
              }
            },
            builder: (context, state) {
              if (state is ShareProjectLoadingState) {
                return const AppLoadingIndicator();
              } else {
                return AppButton(
                  title: AppLocalizations.of(context)!.shareProjectButton,
                  onTap: () {
                    if (_emailController.text != "" && _formKey.currentState!.validate()) {
                      BlocProvider.of<ProjectBloc>(context).add(ShareProjectEvent(projectModel: projectModel, email: _emailController.text));
                    } else {
                      AppToastMessage().showToastMsg(AppLocalizations.of(context)!.emailError, ToastState.error);
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

  Widget _usersInProject() {
    return Column(
      children: [
        AppTitleText(text: AppLocalizations.of(context)!.usersInProject),
        BlocConsumer<UserProjectBloc, UserProjectState>(
          listener: (context, state) {
            if (state is UserProjectListSuccessState) {
              userList = state.userProjectList;
            } else if (state is UserProjectFailureState) {
              AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
            }
          },
          builder: (context, state) {
            if (state is UserProjectLoadingState) {
              return const AppLoadingIndicator();
            } else {
              return AppListView(listData: userList, itemBuilder: _itemBuilder);
            }
          },
        ),
      ],
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (userList[index].isOwner) const Icon(Icons.key, size: 20),
              if (userList[index].isOwner) const SizedBox(width: 10),
              Text(userList[index].user.userName ?? ""),
            ],
          ),
          Text(
            userList[index].user.email,
          ),
        ],
      ),
      onDelete: (value) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AppModalDialog(
            title: AppLocalizations.of(context)!.deleteUserProject,
            content: AppLocalizations.of(context)!.deleteUserProjectContent,
            onTap: () {
              BlocProvider.of<ProjectBloc>(context).add(DeleteUserFromProjectEvent(userProjectModel: userList[index]));
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
