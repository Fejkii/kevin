import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/project/share_project_widget.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/buttons/app_button.dart';
import 'package:kevin/ui/widgets/texts/app_subtitle_text.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  AppPreferences appPreferences = instance<AppPreferences>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _bodyWidget(),
      appBar: AppBar(
        title: Text(appPreferences.getUserProject()!.project.title),
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        const ShareProjectWidget(),
        const Divider(height: 40),
        AppSubTitleText(title: "${AppLocalizations.of(context)!.projectName}: ${appPreferences.getUserProject()!.project.title}"),
        const SizedBox(height: 20),
        AppButton(
          title: AppLocalizations.of(context)!.showUserProjectList,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.projectList);
          },
        ),
      ],
    );
  }
}
