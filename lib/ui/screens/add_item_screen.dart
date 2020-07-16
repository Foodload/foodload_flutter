import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodload_flutter/ui/widgets/add_item.dart';

class AddItemScreen extends StatefulWidget {
  static const routeName = '/add-item';

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add item'),
      ),
      body: AddItem(),
    );
  }
}
