import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pregnancy_baby_app/core/constants/app_routes.dart';
import 'package:pregnancy_baby_app/core/theme/app_theme.dart';
import 'package:pregnancy_baby_app/l10n/app_localizations.dart';
import 'package:pregnancy_baby_app/routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
    return MaterialApp(
      title: 'Pregnancy & Baby Care',
      debugShowCheckedModeBanner: false,
      
      // Use the new theme from AppTheme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

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

      //routing
      initialRoute: AppRoutes.splash,
      routes: appRoutes,
    );
  }
}
