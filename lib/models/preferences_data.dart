import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoulapp/models/lesson.dart';
import 'package:shoulapp/network/network_helper.dart';
import 'package:shoulapp/utilities/u_title.dart';

import 'day.dart';

class PreferencesData extends ChangeNotifier {
  SharedPreferences sharedPreferences;

  Map<String, dynamic> _playedAtNow = {};
  List<String> listStartingMessages = [];
  List<Lesson> listSelectedWeekLesson = [];
  List<Lesson> listFavouriteLessons = [];
  List<String> _listCompletedLessons = [];

  dynamic _listDaysLesson;
  bool shownMessage;

  PreferencesData() {
    //_initListDaysLesson();
    _init();
    _initListCompletedLessons();

    shownMessage = hasToDisplayMessage();
  }

  void _init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic map = sharedPreferences.get('playedAtNow');
    _playedAtNow = (map != null) ? jsonDecode(map) : _playedAtNow = {};

    //print(_playedAtNow);
  }

  Future<List<Lesson>> setListSelectedWeekLesson(Day day) async {
    listSelectedWeekLesson = await NetworkHelper.getVoice(day.date);

    for (var lesson in listSelectedWeekLesson) {
      lesson.date = day.date;
      lesson.hebrewDate = day.hebrewDate;
      lesson.weekNumber = day.weekNumber;

      lesson.iconData = UTitle.getIcon(lesson.title);

      lesson.isCompleted = isLessonCompleted(lesson);
      lesson.isFavouriteLessons = isLessonFavourite(lesson);
    }

    return listSelectedWeekLesson;
  }

  List<Lesson> getListSelectedWeekLesson() {
    return listSelectedWeekLesson;
  }

  bool isLessonCompleted(Lesson lesson) {
    for (var l in _listCompletedLessons) if (l == lesson.title) return true;
    return false;
  }

  bool isLessonFavourite(Lesson lesson) {
    for (var l in listFavouriteLessons)
      if (l.title == lesson.title && l.date == lesson.date) return true;
    return false;
  }

  void _initListCompletedLessons() async {
    _listCompletedLessons =
        await sharedPreferences.getStringList('completedLessons');
  }

  void _updateCompletedLessons() async {
    List<String> completedLessonsS = [];
    for (var lesson in _listCompletedLessons) {
      completedLessonsS.add(lesson);
    }

    await sharedPreferences.setStringList(
        'completedLessons', completedLessonsS);
    print(await sharedPreferences.getStringList('completedLessons'));
    notifyListeners();
  }

  void _updateFavouriteLessons() async {
    await sharedPreferences.setString('playedAtNow', jsonEncode(_playedAtNow));
    //print(await sharedPreferences.getString('playedAtNow'));
  }

  void setHistory(String date, Duration duration) {
    if (duration.inSeconds > 0) {
      _playedAtNow[date] = duration.inSeconds;
      //notifyListeners();
      _updateFavouriteLessons();
    }
  }

  void setCompletedLesson(Lesson lesson) {
    _listCompletedLessons.add(lesson.title);
    _updateCompletedLessons();
  }

  int getHistory(String date) {
    return _playedAtNow[date] ?? 0;
  }

  List<String> getListCompletedLessons() {
    return _listCompletedLessons;
  }

  void addFavouriteLessons(Lesson lesson) {
    listFavouriteLessons.add(lesson);
    notifyListeners();
  }

  List<Lesson> getFavoriteLessons() {}

  void removeFavouriteLessons(Lesson lesson) {
    listFavouriteLessons.remove(lesson);
    notifyListeners();
    //for (var l in listFavouriteLessons) print(l.title);
  }

  bool hasToDisplayMessage() {
    DateFormat format = DateFormat('dd/MM/yyyy');

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    SharedPreferences.getInstance().then((s) {
      String lastOK = s.getString('shownMessage');
      if (lastOK == null) {
        setShownMessage();
        return true;
      }

      DateTime dd = format.parse(lastOK);

      int difference = dd.difference(today).inDays;

      return (difference < 0) ? true : false;
    });
  }

  bool getShownMessage() => hasToDisplayMessage();

  void setShownMessage() async {
    var format = DateFormat('dd/MM/yyyy');
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    var s = await SharedPreferences.getInstance();
    await s.setString('shownMessage', format.format(today));
  }

  List<String> getStartingMessages() {
    return listStartingMessages;
  }

  Future<void> _initListDaysLesson() async {
    _listDaysLesson = await NetworkHelper.getDayLessons();
    //print(_listDaysLesson);
  }

  Future<dynamic> getListDaysLesson() async {
    if (_listDaysLesson == null) await _initListDaysLesson();
    return _listDaysLesson;
  }

  void updateListDaysLesson() {
    _initListDaysLesson();
  }
}
