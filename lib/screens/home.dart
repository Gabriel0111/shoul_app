import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int t = 0;

  @override
  Widget build(BuildContext context) {
    var tab = <Widget>[
      CupertinoButton(
        child: Text('Un'),
        onPressed: () {},
        key: ValueKey<int>(1),
      ),
      CupertinoButton(
        child: Text('Deux'),
        onPressed: () {},
        key: ValueKey<int>(2),
      ),
      CupertinoButton(
        child: Text('Trois'),
        onPressed: () {},
        key: ValueKey<int>(3),
      ),
    ];

    return CupertinoPageScaffold(
      child: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text('Home'),
            ),
            SliverToBoxAdapter(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          child: child,
                          opacity: animation,
                        );
                      },
                      child: tab[t % 3],
                    ),
                    CupertinoButton.filled(
                        child: Text('Change Widget'),
                        onPressed: () {
                          setState(() {
                            t += 1;
                          });
                        }),
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
