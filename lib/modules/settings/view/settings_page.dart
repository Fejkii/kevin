import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/const/app_constant.dart';
import 'package:kevin/modules/auth/bloc/auth_bloc.dart';
import 'package:kevin/modules/auth/data/model/user_model.dart';
import 'package:kevin/modules/auth/view/user_profile_page.dart';
import 'package:kevin/modules/client_message/view/client_message_form.dart';
import 'package:kevin/modules/project/data/model/user_project_model.dart';
import 'package:kevin/modules/wine/view/wine_variety_list_page.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/app_list_tile.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_modal_view.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/buttons/app_button.dart';
import 'package:kevin/ui/widgets/buttons/app_text_button.dart';
import 'package:kevin/ui/widgets/texts/app_subtitle_text.dart';
import 'package:kevin/ui/widgets/texts/app_text_with_value.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../project/view/project_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  late UserProjectModel userProjectModel;
  late UserModel userModel;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() {
    setState(() {
      userModel = appPreferences.getUser();
      userProjectModel = appPreferences.getUserProject();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: _body(context),
    );
  }

  Column _body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 160,
          child: DrawerHeader(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.wine_bar, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 10),
                    AppTitleText(
                      text: AppLocalizations.of(context)!.appName,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                AppSubTitleText(text: userProjectModel.project.title),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(userModel.userName ?? AppConstant.EMPTY),
                    Text(userModel.email),
                  ],
                )
              ],
            ),
          ),
        ),
        AppListTile(
          leading: const Icon(Icons.person),
          title: AppLocalizations.of(context)!.profile,
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfilePage())).then((value) => _getData());
          },
        ),
        const SizedBox(height: 10),
        AppListTile(
          leading: const Icon(Icons.supervised_user_circle),
          title: AppLocalizations.of(context)!.project,
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProjectPage())).then((value) => _getData());
          },
        ),
        const Divider(height: 30),
        AppListTile(
          leading: const Icon(Icons.dataset_outlined),
          title: AppLocalizations.of(context)!.wineVarieties,
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const WineVarietyListPage()));
          },
        ),
        const Divider(height: 40),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LogoutSuccessState) {
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signin, (route) => false);
            } else if (state is AuthFailureState) {
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signin, (route) => false);
            }
          },
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const AppLoadingIndicator();
            } else {
              return Center(
                child: AppButton(
                  title: AppLocalizations.of(context)!.logout,
                  onTap: () {
                    BlocProvider.of<AuthBloc>(context).add(const LogOutEvent());
                  },
                  buttonType: ButtonType.logout,
                ),
              );
            }
          },
        ),
        const Divider(height: 30),
        _appInfo(context),
        const Divider(height: 30),
        _sendMessageToAuthor(),
      ],
    );
  }

  Widget _appInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWithValue(text: AppLocalizations.of(context)!.appVersion, value: "0.0.1"),
          const SizedBox(height: 10),
          AppTextWithValue(text: AppLocalizations.of(context)!.author, value: AppLocalizations.of(context)!.authorName),
          Row(
            children: [
              Text("${AppLocalizations.of(context)!.authorContact}:"),
              AppTextButton(
                title: AppLocalizations.of(context)!.authorEmail,
                fontWeight: FontWeight.bold,
                onTap: () {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: AppConstant.EMAIL,
                    query: _encodeQueryParameters(<String, String>{
                      'subject': 'KEVIN - helpdesk',
                    }),
                  );
                  launchUrl(emailLaunchUri);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }

  Widget _sendMessageToAuthor() {
    return Center(
      child: AppButton(
        title: AppLocalizations.of(context)!.sendMessageToAuthor,
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AppModalView(title: AppLocalizations.of(context)!.sendMessageToAuthor, content: const ClientMessageForm()),
          );
        },
      ),
    );
  }
}
