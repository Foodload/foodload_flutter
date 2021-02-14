import 'package:flutter/material.dart';

class DeletingSnackBar extends SnackBar {
  DeletingSnackBar({
    Key key,
    @required BuildContext context,
    @required VoidCallback onUndo,
    @required String message,
  }) : super(
          key: key,
          content: Text(
            message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: onUndo,
            textColor: Theme.of(context).colorScheme.onError,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
}
