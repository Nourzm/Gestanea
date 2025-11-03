import 'package:flutter/material.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!; // translation object

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appTitle),
        centerTitle: true,
      ),
    );
  }
}
