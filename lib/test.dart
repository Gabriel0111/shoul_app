import 'package:intl/intl.dart';

main() {
  var f = DateFormat('dd/MM/yyyy');

  var n = DateTime.now();
  var d = DateTime(n.year, n.month, n.day);

  var a = '24/07/2020';
  var dd = f.parse(a);

  int difference = dd.difference(d).inDays;

  if (difference < 0)
    print('Doit lire');
  else
    print('OK');
}

//void testD() {
//  var f = DateFormat('dd/MM/yyyy');
//
//  var n = DateTime.now();
//  var d = DateTime(n.year, n.month, n.day);
//
//  var a = '23/07/2020';
//  var dd = f.parse(a);
//
//  print(d.difference(dd).inDays);
//}
//
//int weekNumber(String dateS) {
//  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
//  DateTime date = dateFormat.parse(dateS);
//
//  int julian =
//      int.parse(DateFormat("D").format(date)); // Jan 1 = 1, Jan 2 = 2, etc...
//  int dow = date.weekday; // Sun = 0, Mon = 1, etc...
//  int dowJan1 = int.parse(DateFormat("D").format(DateTime(date.year, 1,
//      1))); // getDayOfWeek("1/1/" + thisYear)   // find out first of year's day
//// int badWeekNum = (julian / 7) + 1  // Get our week# (wrong!  Don't use this)
//  double weekNum =
//      ((julian + 6) / 7); // probably better.  CHECK THIS LINE. (See comments.)
//  if (dow < dowJan1) // adjust for being after Saturday of week #1
//    ++weekNum;
//  return (weekNum.floor());
//}
//
//void hebrewTest() {
//  var h = HebrewDateFormatter();
//  h.setUseFinalFormLetters(true);
//  h.setHebrewFormat(true);
//
//  var d = DateFormat('dd/MM/yyyy');
//
//  var j = JewishDate.fromDateTime(d.parse('21/07/2020'));
//
//  String hebrewDate =
//      ('יום ' + h.formatHebrewNumber(j.getDayOfWeek()) + ' ' + h.format(j));
//}
//
//void parserTest() {
//  initializeDateFormatting("he_IL", null);
//  var now = DateFormat('d/M/yy').parse('23/07/2020');
//  var formatter = DateFormat.yMMMEd('he_IL');
//  print(formatter.locale);
//  String formatted = formatter.format(now);
//  print(formatted);
//
//  final todayInDays = now.difference(new DateTime(now.year, 1, 1, 0, 0)).inDays;
//
//  print((todayInDays / 7).floor());
//}
