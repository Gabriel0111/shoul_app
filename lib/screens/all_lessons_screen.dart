import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoulapp/components/centered_indicator.dart';
import 'package:shoulapp/components/presentation_card.dart';
import 'package:shoulapp/models/day.dart';
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
    _initList();
  }

  void _initList() async {
    listAllLessons = await NetworkHelper.getDayLessons();

    setState(() {
      listAllLessons = listAllLessons['res'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Platform.isIOS) ? getiOSPage() : getAndroidPage();
  }

  Widget getiOSPage() {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: CupertinoScrollbar(
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text('שיעור יומי'),
              ),
              getMainWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAndroidPage() {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text('שיעור יומי'),
            ),
            getMainWidget(),
          ],
        ),
      ),
    );
  }

  Widget getMainWidget() {
    if (listAllLessons == null)
      return SliverFillRemaining(
        hasScrollBody: false,
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
