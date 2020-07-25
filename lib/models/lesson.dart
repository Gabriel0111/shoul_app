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

  Lesson.fromJson(String lesson) {
    Map data = jsonDecode(lesson);

    this.url = data['url'];
    this.title = data['title'];
    this.date = data['date'];
    this.hebrewDate = data['hebrewDate'];
    this.isFavouriteLessons = data['isFavouriteLessons'];
    this.isCompleted = data['isCompleted'];
    this.weekNumber = data['weekNumber'];
    this.iconData = data['iconData'];
  }

  Map toJson() {
    return {
      'url': this.url,
      'title': this.title,
      'date': this.date,
      'hebrewDate': this.hebrewDate,
      'isFavouriteLessons': this.isFavouriteLessons,
      'isCompleted': this.isCompleted,
      'weekNumber': this.weekNumber,
      'iconData': this.iconData
    };
  }
}
