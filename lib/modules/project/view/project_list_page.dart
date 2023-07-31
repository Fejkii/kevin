import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/app_list_view.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';

import '../bloc/user_project_bloc.dart';
import '../data/model/user_project_model.dart';
import 'project_detail_page.dart';

class PojectListPage extends StatefulWidget {
  const PojectListPage({super.key});

  @override
  State<PojectListPage> createState() => _PojectListPageState();
}

class _PojectListPageState extends State<PojectListPage> {
  late List<UserProjectModel> userProjectList;
  AppPreferences appPreferences = instance<AppPreferences>();

  @override
  void initState() {
    userProjectList = [];
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getData() {
    BlocProvider.of<UserProjectBloc>(context).add(UserProjectListByUserEvent(userModel: appPreferences.getUser()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProjectBloc, UserProjectState>(
      builder: (context, state) {
        return AppScaffold(
          body: _getContentWidget(),
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.yourProjects),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.createProject);
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getContentWidget() {
    return SafeArea(
      child: BlocConsumer<UserProjectBloc, UserProjectState>(
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
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (userProjectList[index].isDefault) const Icon(Icons.star, size: 20),
          if (userProjectList[index].isDefault) const SizedBox(width: 10),
          Text(userProjectList[index].project.title),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailPage(userProject: userProjectList[index]),
          ),
        ).then((value) => _getData());
      },
    );
  }
}
