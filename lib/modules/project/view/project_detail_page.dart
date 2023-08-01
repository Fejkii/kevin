import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/modules/project/data/model/user_project_model.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/widgets/buttons/app_button.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';

import '../../../const/app_values.dart';
import '../../../ui/widgets/app_list_view.dart';
import '../../../ui/widgets/app_modal_dialog.dart';
import '../../../ui/widgets/buttons/app_icon_button.dart';
import '../../../ui/widgets/texts/app_text_field.dart';
import '../bloc/project_bloc.dart';
import '../bloc/user_project_bloc.dart';
import '../data/model/project_model.dart';

class ProjectDetailPage extends StatefulWidget {
  final UserProjectModel userProjectModel;
  const ProjectDetailPage({
    Key? key,
    required this.userProjectModel,
  }) : super(key: key);

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _titleFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  late UserProjectModel userProjectModel;
  late List<UserProjectModel> userProjectList;

  @override
  void initState() {
    userProjectModel = widget.userProjectModel;
    _getData();
    _titleController.text = userProjectModel.project.title;
    userProjectList = [];
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _getData() {
    BlocProvider.of<UserProjectBloc>(context).add(UserProjectListByProjectEvent(projectModel: userProjectModel.project));
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
      title: Text(userProjectModel.project.title),
      actions: [
        BlocConsumer<ProjectBloc, ProjectState>(
          listener: (context, state) {
            if (state is ProjectSuccessState) {
              AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastState.success);
              Navigator.pop(context, true);
            } else if (state is ProjectFailureState) {
              AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
            }
          },
          builder: (context, state) {
            if (state is ProjectLoadingState) {
              return const AppLoadingIndicator();
            } else {
              return AppIconButton(
                iconButtonType: IconButtonType.save,
                onPress: (() {
                  if (_titleFormKey.currentState!.validate()) {
                    BlocProvider.of<ProjectBloc>(context).add(
                      UpdateProjectEvent(
                        projectModel: ProjectModel(
                          id: userProjectModel.project.id,
                          title: _titleController.text.trim(),
                        ),
                      ),
                    );
                  }
                }),
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
        _titleForm(context),
        BlocListener<UserProjectBloc, UserProjectState>(
          listener: (context, state) {
            if (state is ProjectLoadingState) {
              const AppLoadingIndicator();
            } else if (state is UserProjectFailureState) {
              AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
            } else if (state is UpdateUserProjectSuccessState) {
              AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updated, ToastState.success);
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
            }
          },
          child: userProjectModel.isDefault
              ? Container()
              : Column(
                  children: [
                    const Divider(height: 40),
                    AppTitleText(text: AppLocalizations.of(context)!.setProjectDefaultContent),
                    const SizedBox(height: 20),
                    AppButton(
                      title: AppLocalizations.of(context)!.setProjectDefault,
                      onTap: () {
                        BlocProvider.of<UserProjectBloc>(context).add(SetProjectDefaultEvent(userProjectModel: userProjectModel));
                      },
                    ),
                  ],
                ),
        ),
        const Divider(height: 40),
        _addUserToProject(context),
        const Divider(height: 40),
        _usersInProject(),
      ],
    );
  }

  Widget _titleForm(BuildContext context) {
    return Form(
      key: _titleFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 10),
          AppTextField(
            controller: _titleController,
            isRequired: true,
            label: AppLocalizations.of(context)!.title,
          ),
        ],
      ),
    );
  }

  Widget _addUserToProject(BuildContext context) {
    return Form(
      key: _emailFormKey,
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
          BlocConsumer<UserProjectBloc, UserProjectState>(
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
                AppToastMessage().showToastMsg(AppLocalizations.of(context)!.shareProjectFailure, ToastState.error);
              } else if (state is DeleteUserProjectFailureState) {
                AppToastMessage().showToastMsg(AppLocalizations.of(context)!.deleteUserProjectFailure, ToastState.error);
              }
            },
            builder: (context, state) {
              if (state is ShareProjectLoadingState) {
                return const AppLoadingIndicator();
              } else {
                return AppButton(
                  title: AppLocalizations.of(context)!.shareProjectButton,
                  onTap: () {
                    if (_emailController.text != "" && _titleFormKey.currentState!.validate()) {
                      BlocProvider.of<UserProjectBloc>(context)
                          .add(ShareProjectEvent(projectModel: userProjectModel.project, email: _emailController.text));
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
              userProjectList = state.userProjectList;
            } else if (state is UserProjectFailureState) {
              AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
            }
          },
          builder: (context, state) {
            if (state is UserProjectLoadingState) {
              return const AppLoadingIndicator();
            } else {
              return AppListView(listData: userProjectList, itemBuilder: _itemBuilder);
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
              if (userProjectList[index].isOwner) const Icon(Icons.key, size: 20),
              if (userProjectList[index].isOwner) const SizedBox(width: 10),
              Text(userProjectList[index].user.userName ?? ""),
            ],
          ),
          Text(
            userProjectList[index].user.email,
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
              BlocProvider.of<UserProjectBloc>(context).add(DeleteUserFromProjectEvent(userProjectModel: userProjectList[index]));
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
