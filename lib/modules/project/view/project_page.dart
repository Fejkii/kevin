import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/modules/project/data/model/user_project_model.dart';
import 'package:kevin/modules/project/view/project_detail_page.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/buttons/app_button.dart';
import 'package:kevin/ui/widgets/texts/app_subtitle_text.dart';

import '../../../ui/widgets/buttons/app_icon_button.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  late UserProjectModel userProjectModel;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() {
    setState(() {
      userProjectModel = appPreferences.getUserProject();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _bodyWidget(),
      appBar: _appBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(userProjectModel.project.title),
      actions: [
        AppIconButton(
          iconButtonType: IconButtonType.edit,
          onPress: (() {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetailPage(userProjectModel: userProjectModel)))
                .then((value) => _getData());
          }),
        ),
      ],
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        AppSubTitleText(text: "${AppLocalizations.of(context)!.projectName}: ${userProjectModel.project.title}"),
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
