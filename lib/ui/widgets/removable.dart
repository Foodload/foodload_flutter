import 'package:flutter/material.dart';

class Removable extends StatelessWidget {
  final key;
  final Future<bool> Function(DismissDirection direction) confirmDismiss;
  final DismissDirectionCallback onDismiss;
  final Widget child;

  const Removable({this.key, this.onDismiss, this.confirmDismiss, this.child})
      : assert(key != null && onDismiss != null && child != null);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(key),
      background: Container(
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30.0,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      confirmDismiss: confirmDismiss,
      direction: DismissDirection.endToStart,
      onDismissed: onDismiss,
      child: child,
    );
  }
}
