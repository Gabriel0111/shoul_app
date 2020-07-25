import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shoulapp/components/presentation_card.dart';
import 'package:shoulapp/models/preferences_data.dart';
import 'package:shoulapp/screens/play_lesson_screen.dart';

class FavouriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var listFavourite =
        Provider.of<PreferencesData>(context).listFavouriteLessons;

    return CupertinoPageScaffold(
      child: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text('שיעורים אהובים'),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
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
            ),
          ],
        ),
      ),
    );
  }
}
