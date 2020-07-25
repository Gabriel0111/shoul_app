import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shoulapp/components/centered_indicator.dart';
import 'package:shoulapp/components/presentation_card.dart';
import 'package:shoulapp/models/day.dart';
import 'package:shoulapp/models/preferences_data.dart';
import 'package:shoulapp/network/network_helper.dart';
import 'package:shoulapp/models/lesson.dart';
import 'package:shoulapp/screens/play_lesson_screen.dart';
import 'package:shoulapp/utilities/u_title.dart';

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
        child: CenteredIndicator(),
      );
    else
      return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          Lesson lesson = listDayLessons[index];

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
                tag: listDayLessons[index].title,
//              child: PresentationCard(
//                title: lesson.title,
//                icon: lesson.iconData,
//                colourID: colourID,
//                isFavouriteLesson: lesson.isFavouriteLessons,
//                isCompleted: lesson.isCompleted,
                child: PresentationCard(lesson)),
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
  Widget build(BuildContext context) {
    _init();

    return CupertinoPageScaffold(
      child: SafeArea(
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
    );
  }
}
//CupertinoActivityIndicator
