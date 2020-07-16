import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:foodload_flutter/ui/widgets/add_item_search_options.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  var _amount = 0;
  var _isSearching = false;

  Future scan() async {
    var options = ScanOptions(
      strings: {
        "cancel": "Cancel",
        "flash_on": "Flash on",
        "flash_off": "Flash off",
      },
    );
    ScanResult result = await BarcodeScanner.scan(
      options: options,
    );
    print(result.rawContent);
  }

  void tada() {
    setState(() {
      _isSearching = !_isSearching;
    });
    print("Tada");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _isSearching
            ? Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : AddItemSearchOptions(tada),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$_amount'),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _amount++;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if (_amount > 0) {
                  setState(() {
                    _amount--;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
