import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/session/session_manager.dart';
import 'package:gestanea/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:gestanea/features/auth/data/models/auth_repo_impl.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_event.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/routes.dart';
import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/main.dart' show routeObserver;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setAppLocale(BuildContext context, Locale locale) {
    // We safely look up the private state object and call its public method.
    // The public signature does not expose the private type.
    context.findAncestorStateOfType<_MyAppState>()?.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // default language
  Locale _locale = const Locale('en');

  // Provide repository & bloc instances as fields so they live with the app life-cycle.
  late final DatabaseHelper _dbHelper;
  late final AuthLocalDataSource _authLocal;
  late final SessionManager _sessionManager;
  late final AuthRepositoryImpl _authRepository;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();

    // Initialize non-async parts synchronously. Opening the DB file happens lazily
    // when DatabaseHelper.database is awaited elsewhere.
    _dbHelper = DatabaseHelper.instance;
    _authLocal = AuthLocalDataSource(_dbHelper);
    _sessionManager = SessionManager();
    _authRepository = AuthRepositoryImpl(
      localDataSource: _authLocal,
      sessionManager: _sessionManager,
    );
    _authBloc = AuthBloc(repository: _authRepository)..add(AppStarted());
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wrap MaterialApp with repository & bloc providers so all routes can access them.
    return RepositoryProvider<AuthRepositoryImpl>.value(
      value: _authRepository,
      child: BlocProvider<AuthBloc>.value(
        value: _authBloc,
        child: MaterialApp(
          title: 'Gestanéa',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            fontFamily: 'Lato',
            primarySwatch: Colors.purple,
            useMaterial3: true,
          ),

          // app language
          locale: _locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          //phone default language
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supported in supportedLocales) {
              if (supported.languageCode == locale?.languageCode) {
                return supported;
              }
            }
            return supportedLocales.first;
          },

          //routing - proper flow with splash → onboarding → login → dashboard
          initialRoute: AppRoutes.splash,
          routes: appRoutes,
          navigatorObservers: [routeObserver],
        ),
      ),
    );
  }
}
