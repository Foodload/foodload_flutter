import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showFailMessage(BuildContext context, String message) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
        ),
      );
  }
}
