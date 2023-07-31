import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/const/images.dart';
import 'package:kevin/ui/widgets/buttons/app_login_button.dart';
import 'package:kevin/ui/widgets/texts/app_subtitle_text.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/auth_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTitleText(text: AppLocalizations.of(context)!.appName),
            const SizedBox(height: 5),
            AppSubTitleText(title: AppLocalizations.of(context)!.appSubtitle),
            const SizedBox(height: 50),
            AppSubTitleText(title: AppLocalizations.of(context)!.signIn),
            const SizedBox(height: 10),
            AppLoginButton(
              text: AppLocalizations.of(context)!.signInWithEmail,
              color: Colors.black,
              image: const AssetImage(ImageAssetPath.email),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
            ),
            AppLoginButton(
              text: AppLocalizations.of(context)!.signInWithGoogle,
              color: Colors.green,
              image: const AssetImage(ImageAssetPath.google),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(const GoogleLogeIn());
              },
            ),
            AppLoginButton(
              text: AppLocalizations.of(context)!.signInWithApple,
              color: Colors.black,
              image: const AssetImage(ImageAssetPath.apple),
              onPressed: () {
                // TODO
              },
            ),
            AppLoginButton(
              text: AppLocalizations.of(context)!.signInWithFacebook,
              color: Colors.blue,
              image: const AssetImage(ImageAssetPath.facebook),
              onPressed: () {
                // TODO
              },
            ),
          ],
        ),
      ),
    );
  }
}
