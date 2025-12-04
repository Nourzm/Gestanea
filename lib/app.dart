import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/routes.dart';
import 'features/auth/logic/auth_cubit.dart';
import 'features/baby/logic/baby_cubit.dart';
import 'features/pregnancy/logic/pregnancy_cubit.dart';
import 'features/health/logic/health_cubit.dart';
import 'features/doctors/logic/doctors_cubit.dart';
import 'features/marketplace/logic/marketplace_cubit.dart';
import 'features/marketplace/logic/cart_cubit.dart';
import 'features/education/logic/education_cubit.dart';
import 'features/profile/logic/profile_cubit.dart';
import 'features/dashboard/logic/dashboard_cubit.dart';

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

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => DashboardCubit()),
        BlocProvider(create: (_) => BabyCubit()),
        BlocProvider(create: (_) => PregnancyCubit()),
        BlocProvider(create: (_) => HealthCubit()),
        BlocProvider(create: (_) => DoctorsCubit()),
        BlocProvider(create: (_) => MarketplaceCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => EducationCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
      ],
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
        initialRoute: AppRoutes.dashboard, // ✅ Start with splash screen
        routes: appRoutes,
      ),
    );
  }
}
