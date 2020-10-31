import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kosher_dart/hebrewcalendar/hebrew_date_formatter.dart';
import 'package:kosher_dart/hebrewcalendar/jewish_date.dart';

class UTitle {
  static List<String> _torah = [
    'תורה',
    'התודה',
    'לימוד',
    'בלק',
    'פרשת',
    'פרשה',
    'בלעם'
  ];
  static List<String> _halaha = [
    'הלכה',
    'הלכתה',
    'כהלכתה',
    'הלכות',
    'בהלכה',
    'הלכה-'
  ];
  static List<String> _navi = ['נביא', 'יהושוע', 'יהושע'];
  static List<String> _mishna = ['משנה'];
  static List<String> _songs = ['שיר'];
  static List<String> _story = ['סיפור', 'סיפורי', 'סיפורים', 'אגדות', 'אגדה'];

  static IconData getIcon(String lessonTitle) {
    var titleWords = lessonTitle.split(' ');

    for (var word in titleWords) {
      if (_torah.contains(word))
        return FontAwesomeIcons.torah;
      else if (_halaha.contains(word))
        return FontAwesomeIcons.balanceScale;
      else if (_navi.contains(word))
        return FontAwesomeIcons.crown;
      else if (_mishna.contains(word))
        return FontAwesomeIcons.book;
      else if (_story.contains(word))
        return FontAwesomeIcons.bookOpen;
      else if (_songs.contains(word)) return FontAwesomeIcons.itunesNote;
    }

    return FontAwesomeIcons.ellipsisH;
  }

  static String getShortcutTitle(String title) {
    String result = 'שיעור';

    var splitedTitle = title.split('-');
    if (splitedTitle.length > 1) {
      result += ' ' + splitedTitle[0];
    }
    return result;
  }

  static String getHebrewDate(String date) {
    var h = HebrewDateFormatter();
    h.setUseFinalFormLetters(true);
    h.setHebrewFormat(true);

    var d = DateFormat('dd/MM/yyyy');
    var j = JewishDate.fromDateTime(d.parse(date));

    String hebrewDate =
        ('יום ' + h.formatHebrewNumber(j.getDayOfWeek()) + ' ' + h.format(j));
    return hebrewDate;
  }

  static int getWeekNumber(String dateS) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    DateTime date = dateFormat.parse(dateS);
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int weekNumber = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (date.weekday == 7) weekNumber += 1;
    return weekNumber;
  }

  static String getTime(Duration d) {
    String minutes = (d.inSeconds / 60).floor().toString();
    String seconds = (d.inSeconds.toInt() % 60).toString();

    return "${minutes.padLeft(2, '0')}:${seconds.padLeft(2, '0')}";
  }
}
