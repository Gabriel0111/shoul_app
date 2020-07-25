import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoulapp/models/day.dart';
import 'package:shoulapp/models/entity.dart';
import 'package:shoulapp/models/lesson.dart';
import 'package:shoulapp/models/preferences_data.dart';
import 'package:shoulapp/network/network_helper.dart';
import '../utilities/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoulapp/screens/day_lesson_screen.dart';

class PresentationCard extends StatefulWidget {
  Day entityToDisplay;

  PresentationCard(this.entityToDisplay);

  @override
  _PresentationCardState createState() => _PresentationCardState();
}

class _PresentationCardState extends State<PresentationCard> {
  List<IconData> favouriteIcons = [
    CupertinoIcons.heart,
    CupertinoIcons.heart_solid
  ];

  Lesson lesson;
  bool isLesson;

  Widget insertIcon() {
    return Expanded(
      flex: 2,
      child: Center(
        child: (isLesson)
            ? FaIcon(
                lesson.iconData,
                color: Colors.primaries[lesson.weekNumber % 17][100],
                size: 30,
              )
            : Icon(null),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      lesson = widget.entityToDisplay as Lesson;
      isLesson = true;
      var provider = Provider.of<PreferencesData>(context);
      if (provider.isLessonFavourite(lesson)) lesson.isCompleted = true;
    } catch (t) {
      isLesson = false;
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[600].withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 12,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.primaries[widget.entityToDisplay.weekNumber % 17][300],
                Colors.primaries[widget.entityToDisplay.weekNumber % 17][800]
              ],
            ),
          ),
          height: 175,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              insertIcon(),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 60,
                        color: Colors.grey[200].withOpacity(0.3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(right: 20.0, left: 20.0),
                                child: Text(
                                  (isLesson)
                                      ? lesson.title
                                      : widget.entityToDisplay.hebrewDate,
                                  style: kTitleCard,
                                ),
                              ),
                            ),
                            isLesson
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        isLesson && lesson.isCompleted
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Icon(
                                                  CupertinoIcons
                                                      .check_mark_circled_solid,
                                                  color: CupertinoColors
                                                      .activeGreen,
                                                ),
                                              )
                                            : SizedBox(),
                                        Icon(
                                          lesson.isFavouriteLessons
                                              ? CupertinoIcons.heart_solid
                                              : CupertinoIcons.heart,
                                          color: CupertinoColors.systemPink,
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
