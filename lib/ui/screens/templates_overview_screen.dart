import 'package:flutter/material.dart';
import 'package:foodload_flutter/ui/widgets/app_drawer.dart';

class TemplatesOverviewScreen extends StatelessWidget {
  static const routeName = '/template-overview-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Templates'),
      ),
      drawer: AppDrawer(),
      body: Center(),
    );
  }
}
