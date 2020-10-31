import 'dart:convert';

import 'package:intl/intl.dart';

import 'models/lesson.dart';

main() {
  String data =
      "[{\"url\":\"https://drive.google.com/u/0/uc?id=1QFW0xcfcFVzdN4Yul3YQ-9Ea1KlAak3V&export=download\",\"title\":\"תורה - ברית בין הבתרים\",\"date\":\"29/10/2020\",\"hebrewDate\":\"יום ה׳ י״א חשון תשפ״א\",\"isFavouriteLessons\":true,\"isCompleted\":false,\"weekNumber\":44},{\"url\":\"https://drive.google.com/u/0/uc?id=1PFKh3349n2sGCEZJFUo5VmYfQ0DZbFjN&export=download\",\"title\":\"נביא - למה דוד לא יכול לבנות בית לה'\",\"date\":\"27/10/2020\",\"hebrewDate\":\"יום ג׳ ט׳ חשון תשפ״א\",\"isFavouriteLessons\":true,\"isCompleted\":false,\"weekNumber\":44},{\"url\":\"https://drive.google.com/u/0/uc?id=1PCg0w1Pd7Grd6LC0bOiYlTI_mjMJ5QND&export=download\",\"title\":\"משנה - שבת יז משנה ד ה\",\"date\":\"27/10/2020\",\"hebrewDate\":\"יום ג׳ ט׳ חשון תשפ״א\",\"isFavouriteLessons\":true,\"isCompleted\":false,\"weekNumber\":44},{\"url\":\"https://drive.google.com/u/0/uc?id=1OiRm8vTVm5AHikHeR302K1SRa_Ir1sl1&export=download\",\"title\":\"תורה - למה ה' לא גילה לאן ללכת\",\"date\":\"27/10/2020\",\"hebrewDate\":\"יום ג׳ ט׳ חשון תשפ״א\",\"isFavouriteLessons\":true,\"isCompleted\":true,\"weekNumber\":44}]";

  var myModels =
      (json.decode(data) as List).map((i) => Lesson.fromJson(i)).toList();

  print(myModels);
}
