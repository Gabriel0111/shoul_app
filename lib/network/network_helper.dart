import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shoulapp/models/lesson.dart';
import 'package:shoulapp/utilities/constants.dart';

class NetworkHelper {
  static final String URL =
      "http://ec2-34-216-149-119.us-west-2.compute.amazonaws.com/service/apps";

  static Future<dynamic> getDayLessons() async {
    var r = await http.post(URL + '/DayLessons/getDays');

    if (r.statusCode == 200) return jsonDecode(r.body);
  }

  static Future<dynamic> getVoice(String date) async {
    var r = await http.post(URL + '/getvoice',
        body: '{"listID": "$date", "screen": "10"}');

    List<Lesson> listLessons = [];

    if (r.statusCode == 200) {
      var content = jsonDecode(r.body)[kRes];

      for (var p in content) {
        listLessons.add(
          Lesson(
            title: p[kName],
            url: p[kURL],
          ),
        );
      }
    }

    return listLessons;
  }

  static String _modifyURL(String URL) {
    return URL.replaceAll('&export=download', '');
  }
}
