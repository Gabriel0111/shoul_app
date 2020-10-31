import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Button extends StatelessWidget {
  final Function onTap;
  final Widget child;
  Button({@required this.onTap, @required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: CupertinoButton(onPressed: onTap, child: child),
    );
  }
}

class SelectedButton extends StatelessWidget {
  final Function onTap;
  final Widget child;
  Color color;
  SelectedButton({@required this.onTap, @required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.0),
      child: (color != null)
          ? CupertinoButton(
              color: color,
              onPressed: onTap,
              child: child,
            )
          : CupertinoButton.filled(
              onPressed: onTap,
              child: child,
            ),
    );
  }
}
