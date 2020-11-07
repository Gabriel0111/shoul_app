import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'day.dart';

class Lesson extends Day {
  String title;
  String url;
  IconData iconData;

  bool isFavouriteLessons = false;
  bool isCompleted = false;

  Lesson({this.url, this.title});

  Lesson.fromString(String lesson) {
    Map data = jsonDecode(lesson);

    this.url = data['url'];
    this.title = data['title'];
    this.date = data['date'];
    this.hebrewDate = data['hebrewDate'];
    this.isFavouriteLessons = data['isFavouriteLessons'];
    this.isCompleted = data['isCompleted'];
    this.weekNumber = data['weekNumber'];

    int codePoint = data['iconData']['codePoint'];
    String fontFamily = data['iconData']['fontFamily'];
    String fontPackage = data['iconData']['fontPackage'];
    bool matchTextDirection = data['iconData']['matchTextDirection'];

    this.iconData = IconData(codePoint,
        fontFamily: fontFamily,
        fontPackage: fontPackage,
        matchTextDirection: matchTextDirection);
  }

  Lesson.fromJson(Map<String, dynamic> lesson) {
    this.url = lesson['url'];
    this.title = lesson['title'];
    this.date = lesson['date'];
    this.hebrewDate = lesson['hebrewDate'];
    this.isFavouriteLessons = lesson['isFavouriteLessons'];
    this.isCompleted = lesson['isCompleted'];
    this.weekNumber = lesson['weekNumber'];

    this.iconData = IconData(lesson['iconData']['codePoint'],
        fontFamily: lesson['iconData']['fontFamily'],
        fontPackage: lesson['iconData']['fontPackage'],
        matchTextDirection: lesson['iconData']['matchTextDirection']);
  }

  Map<String, dynamic> toJson() {
    return {
      "url": this.url,
      "title": this.title,
      "date": this.date,
      "hebrewDate": this.hebrewDate,
      "isFavouriteLessons": this.isFavouriteLessons,
      "isCompleted": this.isCompleted,
      "weekNumber": this.weekNumber,
      "iconData": {
        "codePoint": this.iconData.codePoint,
        "fontFamily": this.iconData.fontFamily,
        "fontPackage": this.iconData.fontPackage,
        "matchTextDirection": this.iconData.matchTextDirection
      }
    };
  }
}
