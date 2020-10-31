import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
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
    //_initListDaysLesson();
    _init();
    //_initFavouriteLessons();
    _initFavouriteLessonsJson();
    _initListCompletedLessons();
  }

  void _initFavouriteLessonsJson() {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      File file = new File(dir.path + "/" + fileName);
      fileExists = file.existsSync();
      if (fileExists) {
        print("Le fichier existe !");
        String content = file.readAsStringSync();
        print(content);
        // file.deleteSync();
        // print("Fichier supprimé");
        // return;
        //List<dynamic> list;
        if (content.isNotEmpty) //fileContent = jsonDecode(content);

        {
          var b = content.split(" ");
          var list = json.decode(content);
          for (var l in list) {
            print(l);
            print(l.toString());
            // var a = Lesson.fromJson(l.toString());
          }
        }

        print(content);
      } else {
        File file = new File(dir.path + "/" + fileName);
        file.createSync();
        fileExists = true;
      }
    });
  }

  //file.writeAsStringSync(jsonEncode(content));

  void writeToFile(String key, String value) {
    print("Writing to file!");
    Map<String, String> content = {key: value};
    if (fileExists) {
      print("File exists");
      Map<String, String> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(jsonEncode(jsonFileContent),
          mode: FileMode.append);
    } else {
      print("File does not exist!");
      //createFile(content, dir, fileName);
    }
    fileContent = jsonDecode(jsonFile.readAsStringSync());
    print(fileContent);
  }

  void addFavouriteLessons(Lesson lesson) {
    listFavouriteLessons.add(lesson);
    File jsonFile = new File(dir.path + "/" + fileName);
    String content = jsonFile.readAsStringSync();
    List<dynamic> jsonFileContent = [];
    if (content.isNotEmpty) jsonFileContent = json.decode(content);
    jsonFileContent.add(lesson.toJson());
    jsonFile.writeAsStringSync("[", mode: FileMode.append);
    jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
    // List<String> list = [];

    // for (Lesson l in listFavouriteLessons) list.add(l.toJson().toString());
    // print(list);
    // sharedPreferences.setStringList('favouriteLessons', list);
    //sharedPreferences.setStringList('favouriteLessons', value)

    notifyListeners();
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

  void removeFavouriteLessons(Lesson lesson) {
    for (var l in listFavouriteLessons.toList())
      if (l.title == lesson.title && l.date == lesson.date)
        listFavouriteLessons.remove(l);
    notifyListeners();
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
