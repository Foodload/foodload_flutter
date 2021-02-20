import 'package:flutter/material.dart';

class Completable extends StatelessWidget {
  final key;
  final Future<bool> Function(DismissDirection direction) confirmDismiss;
  final DismissDirectionCallback onDismiss;
  final Widget child;

  const Completable({this.key, this.onDismiss, this.confirmDismiss, this.child})
      : assert(key != null && onDismiss != null && child != null);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(key),
      background: Container(
        color: Colors.green,
        child: const Icon(
          Icons.done,
          color: Colors.white,
          size: 30.0,
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      confirmDismiss: confirmDismiss,
      direction: DismissDirection.startToEnd,
      onDismissed: onDismiss,
      child: child,
    );
  }
}
