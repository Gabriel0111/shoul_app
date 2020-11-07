import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shoulapp/screens/favourite_screen.dart';

import 'all_lessons_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return getScaffold();
  }

  Widget getScaffold() {
    return (Platform.isIOS) ? getiOSScaffold() : getAndroidScaffold();
  }

  Widget getiOSScaffold() {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.news,
            ),
            label: 'שיעור יומי',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.heart,
            ),
            label: 'מועדפים',
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
            view = CupertinoTabView(builder: (_) => FavouriteScreen());
            break;
        }
        return view;
      },
    );
  }

  /* ---------------- */

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() =>
      [AllLessonsScreen(), /* Home(), */ FavouriteScreen()];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.library_books),
          title: ("\tבית"),
          inactiveColor: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.favorite),
          title: ("\tמועדפים"),
          inactiveColor: CupertinoColors.systemGrey,
        ),
      ];

  Widget getAndroidScaffold() {
    return PersistentTabView(
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: false,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: false,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}
