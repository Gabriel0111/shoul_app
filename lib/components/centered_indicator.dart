import 'package:flutter/cupertino.dart';

class CenteredIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        radius: 15,
      ),
    );
  }
}
