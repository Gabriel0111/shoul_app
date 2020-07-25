import 'package:flutter/cupertino.dart';

class FavouriteButton extends StatelessWidget {
  final Function onTap;
  FavouriteButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(),
      child: CupertinoButton(
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              CupertinoIcons.heart,
              color: CupertinoColors.systemPink,
            ),
            SizedBox(width: 10),
            Text(
              'רשום כשיעור אהוב',
              style: TextStyle(color: CupertinoColors.systemPink),
            ),
          ],
        ),
      ),
    );
  }
}

class FavouriteButtonSelected extends StatelessWidget {
  final Function onTap;
  FavouriteButtonSelected({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: CupertinoButton(
        color: CupertinoColors.systemPink,
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(CupertinoIcons.heart_solid),
            SizedBox(width: 10),
            Text('שיעור אהוב'),
          ],
        ),
      ),
    );
  }
}
