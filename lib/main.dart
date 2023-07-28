import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/bloc/auth/auth_bloc.dart';
import 'package:kevin/bloc/project/project_bloc.dart';
import 'package:kevin/bloc/user_project/user_project_bloc.dart';
import 'package:kevin/bloc/wine/wine_bloc.dart';
import 'package:kevin/bloc/wine_variety/wine_variety_bloc.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/firebase_options.dart';
import 'package:kevin/repository/wine_variety_repository.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/services/route_service.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initAppDependences();
  await instance<AppPreferences>().initSP();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<ProjectBloc>(create: (context) => ProjectBloc()),
        BlocProvider<UserProjectBloc>(create: (context) => UserProjectBloc()),
        BlocProvider<WineBloc>(create: (context) => WineBloc()),
        BlocProvider<WineVarietyBloc>(create: (context) => WineVarietyBloc(WineVarietyRepository())),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: RouteGenerator.onGenerateRoute,
        supportedLocales: const [
          Locale("cs", ""),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
