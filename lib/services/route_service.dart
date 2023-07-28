import 'package:flutter/material.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/modules/settings/view/settings_page.dart';
import 'package:kevin/services/custom_page_route.dart';
import 'package:kevin/ui/auth/forgot_password_page.dart';
import 'package:kevin/ui/auth/login_page.dart';
import 'package:kevin/ui/auth/register_page.dart';
import 'package:kevin/ui/auth/signin_page.dart';
import 'package:kevin/ui/home_page.dart';
import 'package:kevin/ui/project/create_project_page.dart';
import 'package:kevin/ui/project/project_list_page.dart';
import 'package:kevin/ui/project/project_page.dart';
import 'package:kevin/ui/splash_page.dart';
import 'package:kevin/ui/wine/wine_variety_list_page.dart';

class RouteGenerator {
  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRoutes.signin:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case AppRoutes.login:
        return CustomPageRoute(direction: AxisDirection.left, child: const LoginPage());
      case AppRoutes.register:
        return CustomPageRoute(direction: AxisDirection.left, child: const RegisterPage());
      case AppRoutes.forgetPassword:
        return CustomPageRoute(direction: AxisDirection.left, child: const ForgottenPasswordPage());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case AppRoutes.createProject:
        return MaterialPageRoute(builder: (_) => const CreateProjectPage());
      case AppRoutes.project:
        return MaterialPageRoute(builder: (_) => const ProjectPage());
      case AppRoutes.projectList:
        return MaterialPageRoute(builder: (_) => const PojectListPage());
      case AppRoutes.wineVarietyList:
        return MaterialPageRoute(builder: (_) => const WineVarietyListPage());
      default:
        return null;
    }
  }
}
