import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoulapp/components/presentation_card.dart';
import 'package:shoulapp/models/lesson.dart';
import 'package:shoulapp/models/preferences_data.dart';
import 'package:shoulapp/screens/play_lesson_screen.dart';

// ignore: must_be_immutable
class FavouriteScreen extends StatelessWidget {
  List<Lesson> listFavourite;

  @override
  Widget build(BuildContext context) {
    listFavourite = Provider.of<PreferencesData>(context).listFavouriteLessons;

    return (Platform.isIOS) ? getiOSPage() : getAndroidPage();
  }

  Widget getiOSPage() => CupertinoPageScaffold(
        child: SafeArea(
          child: CupertinoScrollbar(
            child: CustomScrollView(
              slivers: <Widget>[
                CupertinoSliverNavigationBar(
                  largeTitle: Text('מועדפים'),
                ),
                (listFavourite.length != 0)
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
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
                            child: Hero(
                              flightShuttleBuilder: _flightShuttleBuilder,
                              tag: listFavourite[index].title,
                              child: PresentationCard(
                                listFavourite[index],
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => PlayLessonScreen(
                                    lessonToPlay: listFavourite[index],
                                  ),
                                ),
                              );
                            },
                          );
                        }, childCount: listFavourite.length),
                      )
                    : SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'אין שיעורים מועדפים כרגע...',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      );

  Widget getAndroidPage() => Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text('מועדפים'),
              ),
              (listFavourite.length != 0)
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return CupertinoButton(
                          child: Hero(
                            tag: listFavourite[index].title,
                            child: PresentationCard(
                              listFavourite[index],
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => PlayLessonScreen(
                                  lessonToPlay: listFavourite[index],
                                ),
                              ),
                            );
                          },
                        );
                      }, childCount: listFavourite.length),
                    )
                  : SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'אין שיעורים מועדפים כרגע...',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
}
