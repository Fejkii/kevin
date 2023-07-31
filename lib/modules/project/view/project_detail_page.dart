import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/modules/project/view/share_project_widget.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/widgets/buttons/app_button.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';

import '../bloc/project_bloc.dart';
import '../bloc/user_project_bloc.dart';
import '../data/model/user_project_model.dart';

class ProjectDetailPage extends StatefulWidget {
  final UserProjectModel userProject;
  const ProjectDetailPage({
    Key? key,
    required this.userProject,
  }) : super(key: key);

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  late UserProjectModel userProject;

  @override
  void initState() {
    userProject = widget.userProject;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _body(),
      appBar: AppBar(
        title: Text(userProject.project.title),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        if (userProject.isOwner) const ShareProjectWidget(),
        const SizedBox(height: 20),
        _setDefaultProject(),
      ],
    );
  }

  Widget _setDefaultProject() {
    return BlocListener<UserProjectBloc, UserProjectState>(
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
      child: userProject.isDefault
          ? AppTitleText(text: AppLocalizations.of(context)!.projectIsDefault)
          : Column(
              children: [
                const SizedBox(height: 20),
                AppTitleText(text: AppLocalizations.of(context)!.setProjectDefaultContent),
                AppButton(
                  title: AppLocalizations.of(context)!.setProjectDefault,
                  onTap: () {
                    BlocProvider.of<UserProjectBloc>(context).add(SetProjectDefaultEvent(userProjectModel: userProject));
                  },
                ),
              ],
            ),
    );
  }
}
