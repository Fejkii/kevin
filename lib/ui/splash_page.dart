import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/theme/app_colors.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _startDelay() {
    _timer = Timer(const Duration(milliseconds: 500), _goNext);
  }

  _goNext() {
    if (appPreferences.isUserLoggedIn()) {
      if (appPreferences.hasUserProject()) {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.createProject, (route) => false);
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signin, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.of(context)!.appName,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTitleText(
                text: AppLocalizations.of(context)!.appName,
              ),
              const SizedBox(
                height: 200,
                width: 200,
                child: Icon(Icons.wine_bar, size: 120),
              ),
              AppTitleText(text: AppLocalizations.of(context)!.appSubtitle),
            ],
          ),
          
        ),

      ),
      theme: ThemeData(
        primaryColor: AppColors.primary
      ),
    );
  }
}
