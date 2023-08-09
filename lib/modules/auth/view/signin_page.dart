import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/const/images.dart';
import 'package:kevin/ui/widgets/buttons/app_login_button.dart';
import 'package:kevin/ui/widgets/texts/app_subtitle_text.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../services/app_preferences.dart';
import '../../../services/dependency_injection.dart';
import '../../../ui/widgets/app_loading_indicator.dart';
import '../../../ui/widgets/app_toast_messages.dart';
import '../bloc/auth_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AppPreferences appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTitleText(text: AppLocalizations.of(context)!.appName),
            const SizedBox(height: 5),
            AppSubTitleText(text: AppLocalizations.of(context)!.appSubtitle),
            const SizedBox(height: 50),
            AppSubTitleText(text: AppLocalizations.of(context)!.signIn),
            const SizedBox(height: 10),
            AppLoginButton(
              text: AppLocalizations.of(context)!.signInWithEmail,
              color: Colors.black,
              image: const AssetImage(ImageAssetPath.email),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
            ),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is LoginSuccessState) {
                  if (appPreferences.getUser().userName == null) {
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.userName, (route) => false);
                  } else if (!appPreferences.hasUserProject()) {
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.createProject, (route) => false);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                  }
                } else if (state is AuthFailureState) {
                  AppToastMessage().showToastMsg(AppLocalizations.of(context)!.loginError, ToastState.error);
                }
              },
              builder: (context, state) {
                if (state is AuthLoadingState) {
                  return const AppLoadingIndicator();
                } else {
                  return AppLoginButton(
                    text: AppLocalizations.of(context)!.signInWithGoogle,
                    color: Colors.green,
                    image: const AssetImage(ImageAssetPath.google),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(const GoogleLogeIn());
                    },
                  );
                }
              },
            ),
            // TODO
            // AppLoginButton(
            //   text: AppLocalizations.of(context)!.signInWithApple,
            //   color: Colors.black,
            //   image: const AssetImage(ImageAssetPath.apple),
            //   onPressed: () {},
            // ),
            // AppLoginButton(
            //   text: AppLocalizations.of(context)!.signInWithFacebook,
            //   color: Colors.blue,
            //   image: const AssetImage(ImageAssetPath.facebook),
            //   onPressed: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
