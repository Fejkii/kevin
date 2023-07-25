import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/bloc/auth/auth_bloc.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/const/app_values.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/texts/app_subtitle_text.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';

class AppSidebar extends StatelessWidget {
  AppSidebar({Key? key}) : super(key: key);
  final AppPreferences appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.wine_bar, color: Theme.of(context).primaryIconTheme.color),
                        const SizedBox(width: 10),
                        AppTitleText(
                          text: AppLocalizations.of(context)!.appName,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    AppSubTitleText(title: appPreferences.getUserProject()!.project.title),
                    const Spacer(),
                    Text(appPreferences.getUser().userName ?? AppConstant.EMPTY),
                    Text(appPreferences.getUser().email),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("Clear preferences"),
                onTap: () {
                  appPreferences.clear();
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.person),
              //   title: Text(AppLocalizations.of(context)!.profile),
              //   onTap: () {
              //     Navigator.popAndPushNamed(context, AppRoutes.userRoute);
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.supervised_user_circle),
                title: Text(AppLocalizations.of(context)!.project),
                onTap: () {
                  Navigator.popAndPushNamed(context, AppRoutes.project);
                },
              ),
              // const Divider(),
              // ListTile(
              //   leading: const Icon(Icons.nature),
              //   title: Text(AppLocalizations.of(context)!.wines),
              //   onTap: () {
              //     Navigator.popAndPushNamed(context, AppRoutes.wineRoute);
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.dataset_outlined),
                title: Text(AppLocalizations.of(context)!.wineVarieties),
                onTap: () {
                  Navigator.popAndPushNamed(context, AppRoutes.wineVarietyList);
                },
              ),
              // const Divider(),
              // ListTile(
              //   leading: const Icon(Icons.settings),
              //   title: Text(AppLocalizations.of(context)!.settings),
              //   onTap: () {
              //     Navigator.popAndPushNamed(context, AppRoutes.settingsRoute);
              //   },
              // ),
              const Divider(),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is LoggedOutState) {
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signin, (route) => false);
                  } else if (state is AuthFailureState) {
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signin, (route) => false);
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return const AppLoadingIndicator();
                  } else {
                    return ListTile(
                      leading: const Icon(Icons.logout),
                      title: Text(AppLocalizations.of(context)!.logout),
                      onTap: () {
                        BlocProvider.of<AuthBloc>(context).add(const LogOutEvent());
                      },
                    );
                  }
                },
              ),
              const Divider(),
              _appVersionInfo(context),
            ],
          ),
        );
      },
    );
  }

  Widget _appVersionInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppLocalizations.of(context)!.appVersion}: 0.0.1',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            '${AppLocalizations.of(context)!.apiVersion}: ',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
