import 'package:flutter/material.dart';

class StorageOverviewScreen extends StatelessWidget {
  static const routeName = '/storage-overview';

  StorageOverviewScreen();

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('$title Overview'),
      ),
      body: Center(
        child: Text(title),
      ),
    );
  }
}
