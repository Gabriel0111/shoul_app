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
    Iterable<LocalizationsDelegate> prefs = [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate
    ];

    if (Platform.isIOS) {
      return CupertinoApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: prefs,
        supportedLocales: [const Locale('he', '')],
        theme: CupertinoThemeData(primaryColor: Color.fromRGBO(0, 175, 200, 1)),
        home: HomeScreen(),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: prefs,
        supportedLocales: [const Locale('he', '')],
        theme: ThemeData(primaryColor: Color.fromRGBO(0, 175, 200, 1)),
        home: HomeScreen(),
      );
    }
  }
}
