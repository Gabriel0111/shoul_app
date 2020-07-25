import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoulapp/components/buttons.dart';
import 'package:shoulapp/components/centered_indicator.dart';
import 'package:shoulapp/components/presentation_card.dart';
import 'package:shoulapp/models/lesson.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shoulapp/models/preferences_data.dart';
import 'package:shoulapp/utilities/u_title.dart';

class PlayLessonScreen extends StatefulWidget {
  final Lesson lessonToPlay;

  PlayLessonScreen({this.lessonToPlay});

  @override
  _PlayLessonScreenState createState() => _PlayLessonScreenState();
}

class _PlayLessonScreenState extends State<PlayLessonScreen> {
  PreferencesData provider;
  AssetsAudioPlayer assetsAudioPlayer;
  bool isReadyToPlay = false;
  bool hasClickedResume = false;
  Duration leftPlayerTime;

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
          metas: Metas(
            artist: 'רב עופר',
            title: widget.lessonToPlay.title,
            album: widget.lessonToPlay.date,
          ),
        ),
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        showNotification: true,
        volume: 1,
        playInBackground: PlayInBackground.enabled,
        phoneCallStrategy: PhoneCallStrategy.pauseOnPhoneCallResumeAfter,
        autoStart: false,
        notificationSettings: NotificationSettings(
          prevEnabled: false,
          nextEnabled: false,
        ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CupertinoButton(
                child: Icon(
                  FontAwesomeIcons.redo,
                  size: 25,
                ),
                onPressed: () async {
                  await assetsAudioPlayer.seekBy(Duration(seconds: 5));
                },
              ),
              assetsAudioPlayer.builderIsPlaying(builder: (context, isPlaying) {
                return CupertinoButton(
                  child: Icon(
                    isPlaying == false
                        ? CupertinoIcons.play_arrow_solid
                        : CupertinoIcons.pause_solid,
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
                  FontAwesomeIcons.undo,
                  size: 25,
                ),
                onPressed: () async {
                  await assetsAudioPlayer.seekBy(Duration(seconds: -5));
                },
              ),
            ],
          ),
          CupertinoButton(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => FadeTransition(
                child: child,
                opacity: animation,
              ),
              child: (hasClickedResume == false && leftPlayerTime.inSeconds > 0)
                  ? Text('חזור לזמן שעזבת - ' + UTitle.getTime(leftPlayerTime))
                  : SizedBox(
                      height: 0,
                    ),
            ),
            onPressed: () async {
              setState(() {
                hasClickedResume = true;
              });
              await assetsAudioPlayer.seek(leftPlayerTime);
              assetsAudioPlayer.playOrPause();
            },
          ),
        ],
      );
  }

  void onTapFavourite() {
    widget.lessonToPlay.isFavouriteLessons =
        !widget.lessonToPlay.isFavouriteLessons;

    widget.lessonToPlay.isFavouriteLessons == true
        ? provider.addFavouriteLessons(widget.lessonToPlay)
        : provider.removeFavouriteLessons(widget.lessonToPlay);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              previousPageTitle: 'חזרה',
              largeTitle:
                  Text(UTitle.getShortcutTitle(widget.lessonToPlay.title)),
            ),
            SliverToBoxAdapter(
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
                    SizedBox(
                      height: 30,
                    ),
                    Directionality(
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
                                    fontWeight: FontWeight.bold,
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
                            return Text(player != null
                                ? UTitle.getTime(player.audio.duration)
                                : '00:00');
                          }),
                        ],
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
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) => FadeTransition(
                        child: child,
                        opacity: animation,
                      ),
                      child: widget.lessonToPlay.isFavouriteLessons
                          ? FavouriteButtonSelected(onTap: onTapFavourite)
                          : FavouriteButton(onTap: onTapFavourite),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
