import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/const/app_routes.dart';
import 'package:kevin/firebase_options.dart';
import 'package:kevin/modules/auth/bloc/user_bloc.dart';
import 'package:kevin/modules/auth/data/repository/user_repository.dart';
import 'package:kevin/modules/client_message/bloc/client_message_bloc.dart';
import 'package:kevin/modules/trade/bloc/trade_bloc.dart';
import 'package:kevin/modules/vineyard/bloc/vineyard_bloc.dart';
import 'package:kevin/modules/vineyard/bloc/vineyard_record_bloc.dart';
import 'package:kevin/modules/vineyard/bloc/vineyard_wine_bloc.dart';
import 'package:kevin/modules/wine/bloc/wine_bloc.dart';
import 'package:kevin/modules/wine/bloc/wine_classification_bloc.dart';
import 'package:kevin/modules/wine/bloc/wine_record_bloc.dart';
import 'package:kevin/modules/wine/bloc/wine_variety_bloc.dart';
import 'package:kevin/modules/wine/data/repository/wine_classification_repository.dart';
import 'package:kevin/modules/wine/data/repository/wine_variety_repository.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/services/language_service.dart';
import 'package:kevin/services/route_service.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/ui/theme/app_theme.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';

import 'modules/auth/bloc/auth_bloc.dart';
import 'modules/project/bloc/project_bloc.dart';
import 'modules/project/bloc/user_project_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
  }

  await initAppDependences();
  await instance<AppPreferences>().initSP();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    ConnectivityResult connectionStatus = await _connectivity.checkConnectivity();

    if (connectionStatus != ConnectivityResult.none) {
      AppToastMessage().showToastMsg("Připojení: ${connectionStatus.toString()}", ToastState.success);
    } else {
      AppToastMessage().showToastMsg("Žádné připojení: ${connectionStatus.toString()}", ToastState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<UserBloc>(create: (context) => UserBloc(UserRepository())),
        BlocProvider<ProjectBloc>(create: (context) => ProjectBloc()),
        BlocProvider<UserProjectBloc>(create: (context) => UserProjectBloc()),
        BlocProvider<WineBloc>(create: (context) => WineBloc()),
        BlocProvider<WineVarietyBloc>(create: (context) => WineVarietyBloc(WineVarietyRepository())),
        BlocProvider<WineClassificationBloc>(create: (context) => WineClassificationBloc(WineClassificationRepository())),
        BlocProvider<WineRecordBloc>(create: (context) => WineRecordBloc()),
        BlocProvider<VineyardBloc>(create: (context) => VineyardBloc()),
        BlocProvider<VineyardWineBloc>(create: (context) => VineyardWineBloc()),
        BlocProvider<VineyardRecordBloc>(create: (context) => VineyardRecordBloc()),
        BlocProvider<TradeBloc>(create: (context) => TradeBloc()),
        BlocProvider<ClientMessageBloc>(create: (context) => ClientMessageBloc()),
      ],
      child: MaterialApp(
        locale: Locale(instance<AppPreferences>().getAppLanguage()),
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: RouteGenerator.onGenerateRoute,
        supportedLocales: [
          Locale(LanguageCodeEnum.czech.getValue(), ""),
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
