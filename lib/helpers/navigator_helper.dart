import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class NavigatorHelper {
  //TODO: Implement other helper methods

  static dynamic push(
      {@required BuildContext context, @required Widget child}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return child;
        },
      ),
    );
  }
}
