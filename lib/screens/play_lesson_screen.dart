import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoulapp/components/buttons.dart';
import 'package:shoulapp/components/centered_indicator.dart';
import 'package:shoulapp/components/presentation_card.dart';
import 'package:shoulapp/models/lesson.dart';
import 'package:shoulapp/models/preferences_data.dart';
import 'package:shoulapp/utilities/u_title.dart';

class PlayLessonScreen extends StatefulWidget {
  final Lesson lessonToPlay;

  PlayLessonScreen({this.lessonToPlay});

  @override
  _PlayLessonScreenState createState() => _PlayLessonScreenState();
}

class _PlayLessonScreenState extends State<PlayLessonScreen> {
  bool isiOS;
  PreferencesData provider;
  PreferencesData providerList;
  AssetsAudioPlayer assetsAudioPlayer;
  bool isReadyToPlay = false;
  bool hasClickedResume = false;
  Duration leftPlayerTime;

  int indexPlaying = 0;
  int speedIndex = 0;
  List<double> listSpeed = [1, 1.25, 1.5, 2, 0.75];

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() async {
    assetsAudioPlayer = AssetsAudioPlayer();
    provider = Provider.of<PreferencesData>(context, listen: false);
    leftPlayerTime = Duration(
        seconds: provider.getHistory(
            widget.lessonToPlay.date + ' * ' + widget.lessonToPlay.title));

    if (leftPlayerTime.inSeconds > 0) {
      print('LAST DURATION : ' + leftPlayerTime.toString());
    }

    assetsAudioPlayer.playlistAudioFinished.listen((finished) {
      if (mounted == true)
        setState(() {
          widget.lessonToPlay.isCompleted = true;
          provider.setCompletedLesson(widget.lessonToPlay);
        });
    });

    assetsAudioPlayer.onReadyToPlay.listen((event) {
      print("C'est bon !!!!!!!!!!!!!!!!!!!!!");

      if (mounted == true)
        setState(() {
          isReadyToPlay = true;
        });
    });

    try {
      await assetsAudioPlayer.open(
        Audio.network(
          widget.lessonToPlay.url,
          playSpeed: listSpeed[indexPlaying],
          metas: Metas(
            title: widget.lessonToPlay.title,
            artist: 'רב עופר בן יהודה',
          ),
        ),
        volume: 1,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        showNotification: true,
        playInBackground: PlayInBackground.enabled,
        //phoneCallStrategy: PhoneCallStrategy.pauseOnPhoneCallResumeAfter,
        autoStart: false,
        notificationSettings: NotificationSettings(
          prevEnabled: false,
          nextEnabled: false,
        ),
        playSpeed: listSpeed[speedIndex],
      );
    } catch (t) {
      print(t);
    }
  }

  @override
  void dispose() {
    super.dispose();
    var currentDuration = assetsAudioPlayer.currentPosition.value;
    assetsAudioPlayer.dispose();
    provider.setHistory(
        widget.lessonToPlay.date + ' * ' + widget.lessonToPlay.title,
        currentDuration);
    print('FIN //// : ' + currentDuration.toString());
  }

  Widget _getPlayerWidget() {
    if (isReadyToPlay == false)
      return Container(
        margin: EdgeInsets.all(30),
        child: CenteredIndicator(),
      );
    else
      return Column(
        children: <Widget>[
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CupertinoButton(
                  child: Icon(
                    FontAwesomeIcons.undo,
                    size: 25,
                  ),
                  onPressed: () async {
                    await assetsAudioPlayer.seekBy(Duration(seconds: -5));
                  },
                ),
                assetsAudioPlayer.builderIsPlaying(
                    builder: (context, isPlaying) {
                  return CupertinoButton(
                    child: Icon(
                      isPlaying == false
                          ? (isiOS)
                              ? CupertinoIcons.play_arrow_solid
                              : Icons.play_arrow
                          : (isiOS)
                              ? CupertinoIcons.pause_solid
                              : Icons.pause,
                      size: 75,
                    ),
                    onPressed: () {
                      assetsAudioPlayer.playOrPause();
                      if (mounted == true) setState(() {});
                    },
                  );
                }),
                CupertinoButton(
                  child: Icon(
                    FontAwesomeIcons.redo,
                    size: 25,
                  ),
                  onPressed: () async {
                    await assetsAudioPlayer.seekBy(Duration(seconds: 5));
                  },
                ),
              ],
            ),
          ),
          (hasClickedResume == false && leftPlayerTime.inSeconds > 0)
              ? CupertinoButton(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) => FadeTransition(
                      child: child,
                      opacity: animation,
                    ),
                    child: Text(
                        'חזור לקטע האחרון - ' + UTitle.getTime(leftPlayerTime)),
                  ),
                  onPressed: () async {
                    setState(() {
                      hasClickedResume = true;
                    });
                    await assetsAudioPlayer.seek(leftPlayerTime);
                    assetsAudioPlayer.playOrPause();
                  },
                )
              : SizedBox(),
        ],
      );
  }

  void onTapFavourite() {
    setState(() {
      widget.lessonToPlay.isFavouriteLessons =
          !widget.lessonToPlay.isFavouriteLessons;
    });

    widget.lessonToPlay.isFavouriteLessons == true
        ? providerList.addFavouriteLessons(widget.lessonToPlay)
        : providerList.removeFavouriteLessons(widget.lessonToPlay);
  }

  @override
  Widget build(BuildContext context) {
    isiOS = Platform.isIOS;

    providerList = Provider.of<PreferencesData>(context);

    return (isiOS) ? getiOSPage() : getAndroidPage();
  }

  Widget getiOSPage() {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              previousPageTitle: 'חזרה',
              largeTitle:
                  Text(UTitle.getShortcutTitle(widget.lessonToPlay.title)),
            ),
            getMainWidget()
          ],
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
              title: Text(UTitle.getShortcutTitle(widget.lessonToPlay.title)),
            ),
            getMainWidget()
          ],
        ),
      ),
    );
  }

  Widget getMainWidget() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: widget.lessonToPlay.title,
              child: PresentationCard(
                widget.lessonToPlay,
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    PlayerBuilder.currentPosition(
                        player: assetsAudioPlayer,
                        builder: (context, duration) {
                          return Text(
                            UTitle.getTime(duration),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                            ),
                          );
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    Text('|'),
                    SizedBox(
                      width: 10,
                    ),
                    assetsAudioPlayer.builderCurrent(
                      builder: (context, player) {
                        return Text(
                          player != null
                              ? UTitle.getTime(player.audio.duration)
                              : '00:00',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  child: child,
                  opacity: animation,
                );
              },
              child: _getPlayerWidget(),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          child: child,
                          opacity: animation,
                        );
                      },
                      child: Button(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(' ${listSpeed[speedIndex]}',
                                style: TextStyle(fontSize: 22)),
                            Icon((isiOS) ? CupertinoIcons.clear : Icons.clear),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            speedIndex = (speedIndex + 1) % listSpeed.length;
                            try {
                              assetsAudioPlayer
                                  .setPlaySpeed(listSpeed[speedIndex]);
                            } catch (t) {}
                          });
                        },
                      )),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) => FadeTransition(
                      child: child,
                      opacity: animation,
                    ),
                    child: widget.lessonToPlay.isFavouriteLessons
                        ? SelectedButton(
                            onTap: onTapFavourite,
                            color: (isiOS)
                                ? CupertinoColors.systemPink
                                : Colors.pinkAccent,
                            child: Icon(
                              (isiOS)
                                  ? CupertinoIcons.heart_solid
                                  : Icons.favorite,
                              size: 30,
                            ),
                          )
                        : Button(
                            onTap: onTapFavourite,
                            child: Icon(
                              (isiOS)
                                  ? CupertinoIcons.heart
                                  : Icons.favorite_border,
                              color: (isiOS)
                                  ? CupertinoColors.systemPink
                                  : Colors.pinkAccent,
                              size: 30,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
