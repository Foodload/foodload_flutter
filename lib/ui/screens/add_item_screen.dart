import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Antonio/Documents/foodload_flutter/lib/ui/widgets/add_item/add_item_amount.dart';
import 'file:///C:/Users/Antonio/Documents/foodload_flutter/lib/ui/widgets/add_item/add_item_search_options.dart';

class AddItemScreen extends StatefulWidget {
  static const routeName = '/add-item';

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  var _isSearching = false;

  void dummySearch() {
//    setState(() {
//      _isSearching = !_isSearching;
//    });
    print('Tada!');
  }

  void dummyAmount(var amount) {
    print(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add item'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _isSearching
                ? Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : AddItemSearchOptions(dummySearch),
            SizedBox(height: 20),
            AddItemAmount(dummyAmount),
          ],
        ),
      ),
    );
  }
}
