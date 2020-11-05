import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shoulapp/models/preferences_data.dart';
import 'package:shoulapp/screens/home_screen.dart';
import 'dart:ui';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PreferencesData>(
        create: (context) => PreferencesData(), child: getApp());
  }

  Widget getApp() {
    if (Platform.isIOS) {
      return CupertinoApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [const Locale('he', '')],
        home: HomeScreen(),
      );
    } else {
      return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [const Locale('he', '')],
        home: HomeScreen(),
      );
    }
  }
}
