import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoulapp/components/centered_indicator.dart';
import 'package:shoulapp/components/presentation_card.dart';
import 'package:shoulapp/models/day.dart';
import 'package:shoulapp/models/lesson.dart';
import 'package:shoulapp/models/preferences_data.dart';
import 'package:shoulapp/network/network_helper.dart';
import 'package:shoulapp/utilities/constants.dart';
import 'package:shoulapp/utilities/u_title.dart';

import 'day_lesson_screen.dart';

class AllLessonsScreen extends StatefulWidget {
  @override
  _AllLessonsScreenState createState() => _AllLessonsScreenState();
}

class _AllLessonsScreenState extends State<AllLessonsScreen> {
  dynamic listAllLessons;
  PreferencesData provider;

  @override
  void initState() {
    super.initState();
    _initProviderAndShowMessage();
    _initList();
  }

  void _initProviderAndShowMessage() {
    provider = Provider.of<PreferencesData>(context, listen: false);
//    if (provider.getShownMessage() == null) showStartingMessage();
  }

  void _initList() async {
    listAllLessons = await NetworkHelper.getDayLessons();

    setState(() {
      listAllLessons = listAllLessons['res'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text('שיעור יומי'),
            ),
            getMainWidget(),
          ],
        ),
      ),
    );
  }

//  void showStartingMessage() async {
//    showCupertinoDialog(
//      context: context,
//      builder: (context) => CupertinoAlertDialog(
//        title: Text('לעילוי נשמת'),
//        content: Column(
//          children: <Widget>[
//            Text('הלימוד היומי מוקדש לעילוי נשמת'),
//            SizedBox(
//              height: 10,
//            ),
//            Text(
//              'שלמה בן אליהו',
//              style: TextStyle(fontWeight: FontWeight.bold),
//            ),
//          ],
//        ),
//        actions: <Widget>[
//          CupertinoDialogAction(
//            isDefaultAction: true,
//            child: Text('הבנתי'),
//            onPressed: () {
//              provider.setShownMessage();
//              Navigator.of(context).pop();
//            },
//          ),
//        ],
//      ),
//    );
//  }

  Widget getMainWidget() {
    if (listAllLessons == null)
      return SliverFillRemaining(
        child: CenteredIndicator(),
      );
    else {
      return SliverGrid(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            String date = listAllLessons[index][kID];
            String hebrewDate = UTitle.getHebrewDate(date);
            int weekNumber = UTitle.getWeekNumber(date);

            Day day = Day(
              date: date,
              hebrewDate: hebrewDate,
              weekNumber: weekNumber,
            );

            return CupertinoButton(
              child: PresentationCard(day),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => DayLessonScreen(currentDay: day),
                  ),
                );
              },
            );
          },
          childCount: listAllLessons == null ? 0 : listAllLessons.length,
        ),
      );
    }
  }
}
