import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/bloc/project/project_bloc.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/const/app_values.dart';
import 'package:kevin/models/user_project_model.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/widgets/buttons/app_button.dart';
import 'package:kevin/ui/widgets/texts/app_text_field.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({Key? key}) : super(key: key);

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool _isDefaultValue = false;
  late bool hasUserProject;
  late List<UserProjectModel> userProjectList;

  @override
  void initState() {
    userProjectList = [];
    hasUserProject = instance<AppPreferences>().hasUserProject();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProjectBloc, ProjectState>(listener: (context, state) {}),
      ],
      child: AppScaffold(
        body: _bodyWidget(),
        appBar: AppBar(),
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        AppTitleText(text: hasUserProject ? AppLocalizations.of(context)!.nextProject : AppLocalizations.of(context)!.noProject),
        const SizedBox(height: 20),
        _form(context),
        // _getSharedProjects()
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
          const SizedBox(height: 20),
          BlocConsumer<ProjectBloc, ProjectState>(
            listener: (context, state) {
              if (state is ProjectSuccessState) {
                setState(() {
                  _titleController.text = AppConstant.EMPTY;
                  _isDefaultValue = false;
                });
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
              } else if (state is CreateProjectFailureState) {
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
                      BlocProvider.of<ProjectBloc>(context).add(CreateProjectEvent(title: _titleController.text, isDefault: _isDefaultValue));
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

  // Widget _getSharedProjects() {
  //   return userProjectList.isNotEmpty
  //       ? Column(
  //           children: [
  //             const SizedBox(height: AppPadding.p20),
  //             AppTitleText(text: AppLocalizations.of(context)!.sharedProject),
  //             AppContentText(text: AppLocalizations.of(context)!.selectProject),
  //             SafeArea(
  //               child: BlocConsumer<UserProjectCubit, UserProjectState>(
  //                 listener: (context, state) {
  //                   if (state is UserProjectListSuccessState) {
  //                     userProjectList = state.userProjectList;
  //                   } else if (state is UserProjectFailureState) {
  //                     AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
  //                   }
  //                 },
  //                 builder: (context, state) {
  //                   if (state is UserProjectLoadingState) {
  //                     return const AppLoadingIndicator();
  //                   } else {
  //                     return AppListView(listData: userProjectList, itemBuilder: _itemBuilder);
  //                   }
  //                 },
  //               ),
  //             ),
  //           ],
  //         )
  //       : Container();
  // }

  // Widget _itemBuilder(BuildContext context, int index) {
  //   return AppListViewItem(
  //     itemBody: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         if (userProjectList[index].isDefault) const Icon(Icons.star, size: AppSize.s20),
  //         if (userProjectList[index].isDefault) const SizedBox(width: AppPadding.p10),
  //         Text(userProjectList[index].project!.title),
  //       ],
  //     ),
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => UserProjectDetailView(userProject: userProjectList[index]),
  //         ),
  //       );
  //     },
  //   );
  // }
}
