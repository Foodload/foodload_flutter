import 'package:flutter/material.dart';

class MoveItem extends StatelessWidget {
  final String toStorage;

  const MoveItem(this.toStorage);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.remove_circle),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () => {},
        ),
        Container(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Move to ',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                toStorage,
                style: TextStyle(
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () => {},
        ),
      ],
    );
  }
}
