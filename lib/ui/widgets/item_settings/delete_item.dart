import 'package:flutter/material.dart';

class DeleteItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        color: Theme.of(context).colorScheme.error,
        child: Text(
          'Delete',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}
