import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoulapp/components/centered_indicator.dart';
import 'package:shoulapp/components/presentation_card.dart';
import 'package:shoulapp/models/day.dart';
import 'package:shoulapp/models/preferences_data.dart';
import 'package:shoulapp/models/lesson.dart';
import 'package:shoulapp/screens/play_lesson_screen.dart';

class DayLessonScreen extends StatefulWidget {
  final Day currentDay;

  DayLessonScreen({this.currentDay});

  @override
  _DayLessonScreenState createState() => _DayLessonScreenState();
}

class _DayLessonScreenState extends State<DayLessonScreen> {
  List<Lesson> listDayLessons;
  PreferencesData provider;

  Widget getMainWidget() {
    if (listDayLessons == null)
      return SliverFillRemaining(
        hasScrollBody: false,
        child: CenteredIndicator(),
      );
    else
      return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          Lesson lesson = listDayLessons[index];

          Widget _flightShuttleBuilder(
            BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection flightDirection,
            BuildContext fromHeroContext,
            BuildContext toHeroContext,
          ) {
            return DefaultTextStyle(
              style: DefaultTextStyle.of(toHeroContext).style,
              child: toHeroContext.widget,
            );
          }

          return CupertinoButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => PlayLessonScreen(
                    lessonToPlay: listDayLessons[index],
                  ),
                ),
              );
            },
            child: Hero(
              flightShuttleBuilder: _flightShuttleBuilder,
              tag: listDayLessons[index].title,
              child: PresentationCard(lesson),
            ),
          );
        }, childCount: listDayLessons.length),
      );
  }

  void _init() async {
    provider = Provider.of<PreferencesData>(context, listen: false);
    listDayLessons =
        await provider.setListSelectedWeekLesson(widget.currentDay);

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    provider.listSelectedWeekLesson = null;
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return (Platform.isIOS) ? getiOSPage() : getAndroidPage();
  }

  Widget getiOSPage() {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: CupertinoScrollbar(
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                previousPageTitle: 'שיעור יומי',
                largeTitle: Text(widget.currentDay.hebrewDate),
              ),
              getMainWidget()
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
              title: Text(widget.currentDay.hebrewDate),
            ),
            getMainWidget()
          ],
        ),
      ),
    );
  }
}
//CupertinoActivityIndicator
