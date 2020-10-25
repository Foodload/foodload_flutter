import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class AddItemInfo extends StatelessWidget {
  final String title;
  final String brand;
  final Function changeHandler;

  const AddItemInfo({
    @required this.title,
    @required this.brand,
    @required this.changeHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        child: Column(
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              brand,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                'Change',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              onPressed: changeHandler,
            ),
          ],
        ),
      ),
    );
  }
}
