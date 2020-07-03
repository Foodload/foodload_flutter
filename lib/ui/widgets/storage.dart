import 'package:flutter/material.dart';

class Storage extends StatelessWidget {
  final title;
  final imagePath;
  final namedRoute;

  const Storage({this.title, this.imagePath, this.namedRoute});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.hardEdge,
      child: Ink.image(
        image: AssetImage(
          imagePath,
        ),
        width: 140,
        height: 140,
        fit: BoxFit.cover,
        child: Stack(
          children: <Widget>[
            InkWell(
              onTap: () {
                print('$namedRoute from $title');
              },
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                color: Colors.black54,
                width: 140,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Text(
                  title,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
