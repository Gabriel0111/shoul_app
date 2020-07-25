import 'package:shoulapp/models/entity.dart';

class Day extends Entity {
  String date;
  String hebrewDate;
  int weekNumber;

  Day({this.date, this.hebrewDate, this.weekNumber});
}
