import 'package:flutter/material.dart';
import 'package:foodload_flutter/models/storage_overview_argument.dart';
import 'package:foodload_flutter/models/storage_type.dart';
import 'package:foodload_flutter/ui/screens/storage_overview_screen.dart';

class Storage extends StatelessWidget {
  final title;
  final imagePath;
  final StorageType storageType;

  const Storage({
    this.title,
    this.imagePath,
    this.storageType,
  });

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
                Navigator.of(context).pushNamed(
                  StorageOverviewScreen.routeName,
                  arguments: StorageOverviewArgument(
                    title: title,
                    storageType: storageType,
                  ),
                );
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
