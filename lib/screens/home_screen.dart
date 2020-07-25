import 'package:flutter/cupertino.dart';
import 'package:shoulapp/screens/favourite_screen.dart';

import 'all_lessons_screen.dart';
import 'home.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.news,
            ),
            title: Text('שיעור יומי'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.delete,
            ),
            title: Text('בית'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.heart,
            ),
            title: Text('מועדפים'),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        CupertinoTabView view;
        switch (index) {
          case 0:
            view = CupertinoTabView(builder: (_) => AllLessonsScreen());
            break;
          case 1:
            view = CupertinoTabView(builder: (_) => Home());
            break;
          case 2:
            view = CupertinoTabView(builder: (_) => FavouriteScreen());
        }
        return view;
      },
    );
  }
}
