import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoulapp/models/lesson.dart';
import 'package:shoulapp/network/network_helper.dart';
import 'package:shoulapp/utilities/u_title.dart';
import 'package:path_provider/path_provider.dart';

import 'day.dart';

class PreferencesData extends ChangeNotifier {
  SharedPreferences sharedPreferences;

  Map<String, dynamic> _playedAtNow = {};
  List<Lesson> listSelectedWeekLesson = [];
  List<Lesson> listFavouriteLessons = [];
  List<String> _listCompletedLessons = [];

  Map<String, dynamic> fileContent;

  File jsonFile;
  Directory dir;
  String fileName = "favourites.json";
  bool fileExists = false;

  PreferencesData() {
    _init();
  }

  Future<void> _initFavouriteLessons() async {
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      File file = new File(dir.path + "/" + fileName);
      fileExists = await file.exists();
      if (fileExists) {
        // file.deleteSync();
        // return;

        String fileContent = await file.readAsString();
        if (fileContent.isNotEmpty) {
          List<dynamic> jsonFileContent = json.decode(fileContent);
          for (var lesson in jsonFileContent)
            listFavouriteLessons.add(Lesson.fromJson(lesson));
          notifyListeners();
        }
      } else {
        File file = new File(dir.path + "/" + fileName);
        await file.create();
        fileExists = true;
      }
    });
  }

  // void writeToFile(String key, String value) {
  //   print("Writing to file!");
  //   Map<String, String> content = {key: value};
  //   if (fileExists) {
  //     print("File exists");
  //     Map<String, String> jsonFileContent =
  //         json.decode(jsonFile.readAsStringSync());
  //     jsonFileContent.addAll(content);
  //     jsonFile.writeAsStringSync(jsonEncode(jsonFileContent),
  //         mode: FileMode.append);
  //   } else {
  //     print("File does not exist!");
  //     //createFile(content, dir, fileName);
  //   }
  //   fileContent = jsonDecode(jsonFile.readAsStringSync());
  //   print(fileContent);
  // }

  Future<void> addFavouriteLessons(Lesson lesson) async {
    listFavouriteLessons.add(lesson);
    File jsonFile = new File(dir.path + "/" + fileName);
    String content = await jsonFile.readAsString();
    List<dynamic> jsonFileContent = [];
    if (content.isNotEmpty) jsonFileContent = json.decode(content);
    jsonFileContent.add(lesson.toJson());
    await jsonFile.writeAsString(jsonEncode(jsonFileContent));

    notifyListeners();
  }

  Future<void> removeFavouriteLessons(Lesson lesson) async {
    listFavouriteLessons.removeWhere((l) => l.url == lesson.url);

    File jsonFile = new File(dir.path + "/" + fileName);

    if (listFavouriteLessons.length > 0) {
      await jsonFile.writeAsString("[");
      await jsonFile.writeAsString(jsonEncode(listFavouriteLessons));
    } else {
      await jsonFile.writeAsString("[]");
    }
    notifyListeners();
  }

  void _init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic map = sharedPreferences.get('playedAtNow');
    _playedAtNow = (map != null) ? jsonDecode(map) : _playedAtNow = {};

    _initFavouriteLessons();
    _initListCompletedLessons();
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

  void _initListCompletedLessons() async {
    _listCompletedLessons = (await SharedPreferences.getInstance())
        .getStringList('completedLessons');
    _listCompletedLessons = _listCompletedLessons ?? [];

    print('listCompletedLessons ' + _listCompletedLessons.toString());
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
    notifyListeners();
  }

  bool isLessonFavourite(Lesson lesson) {
    for (var l in listFavouriteLessons)
      if (l.title == lesson.title && l.date == lesson.date) return true;
    return false;
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
}
