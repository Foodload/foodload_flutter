import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/add_item_form/add_item_form.dart';

class AddItemSearchOptions extends StatefulWidget {
  final TextEditingController _itemIdTextController;

  AddItemSearchOptions(this._itemIdTextController);

  @override
  _AddItemSearchOptionsState createState() => _AddItemSearchOptionsState();
}

class _AddItemSearchOptionsState extends State<AddItemSearchOptions> {
  var _itemIdTextController;
  AddItemFormBloc _addItemFormBloc;

  Future scan() async {
    var options = ScanOptions(
      strings: {
        'cancel': 'Cancel',
        'flash_on': 'Flash on',
        'flash_off': 'Flash off',
      },
    );
    ScanResult result = await BarcodeScanner.scan(
      options: options,
    );

    if (result.type == ResultType.Barcode) {
      _onSearch(result.rawContent);
    }
    //TODO: Prob more error handling
    //print(result.type);
  }

  @override
  void initState() {
    super.initState();
    _addItemFormBloc = BlocProvider.of<AddItemFormBloc>(context);
    _itemIdTextController = widget._itemIdTextController;
    _itemIdTextController.addListener(_onItemIdChanged);
  }

  void _onItemIdChanged() {
    _addItemFormBloc.add(
      ItemIdChanged(
        id: _itemIdTextController.text,
      ),
    );
  }

  void _onSearch(String id) {
    _addItemFormBloc.add(
      ItemIdSearch(id: id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Scan',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: scan,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        Text(
          'Or',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        BlocBuilder<AddItemFormBloc, AddItemFormState>(
          builder: (context, state) => Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Type the ID of the item',
                      ),
                      textInputAction: TextInputAction.search,
                      controller: _itemIdTextController,
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      autovalidate: true,
                      validator: (_) {
                        return !state.isItemIdEntered
                            ? 'Please enter the ID of the item'
                            : null;
                      },
                      onFieldSubmitted: (_) {
                        _onSearch(_itemIdTextController.text);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    color: Theme.of(context).colorScheme.primary,
                    child: Text(
                      'Search',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    onPressed: !state.isItemIdEntered
                        ? null
                        : () {
                            _onSearch(_itemIdTextController.text);
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
