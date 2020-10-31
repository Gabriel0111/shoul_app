import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoulapp/models/day.dart';
import 'package:shoulapp/models/lesson.dart';
import '../utilities/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PresentationCard extends StatefulWidget {
  Day entityToDisplay;

  PresentationCard(this.entityToDisplay);

  @override
  _PresentationCardState createState() => _PresentationCardState();
}

class _PresentationCardState extends State<PresentationCard> {
  Lesson lesson;
  bool isLesson;
  bool isiOS;

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
    isiOS = Platform.isIOS;

    try {
      lesson = widget.entityToDisplay as Lesson;
      isLesson = true;
      //var provider = Provider.of<PreferencesData>(context);
      //if (provider.isLessonFavourite(lesson)) lesson.isFavouriteLessons = true;
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
          height: 168,
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
                        height: 100,
                        color: Colors.grey[200].withOpacity(0.2),
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
                                                  (isiOS)
                                                      ? CupertinoIcons
                                                          .check_mark_circled_solid
                                                      : Icons.check_circle,
                                                  color: (isiOS)
                                                      ? CupertinoColors
                                                          .activeGreen
                                                      : Colors.lightGreenAccent,
                                                ),
                                              )
                                            : SizedBox(),
                                        Icon(
                                          lesson.isFavouriteLessons
                                              ? (isiOS)
                                                  ? CupertinoIcons.heart_solid
                                                  : Icons.favorite
                                              : (isiOS)
                                                  ? CupertinoIcons.heart
                                                  : Icons.favorite_border,
                                          color: (isiOS)
                                              ? CupertinoColors.systemPink
                                              : Colors.pinkAccent,
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
