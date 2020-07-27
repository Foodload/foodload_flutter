import 'package:flutter/material.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/models/item_detail_argument.dart';
//import 'package:foodload_flutter/models/storage_type.dart';

class ItemDetailScreen extends StatefulWidget {
  static const routeName = '/item-detail';

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  var _isInit = false;
  var _showEditAmount = true;
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  Item _item;
  //StorageType _storageType;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      final ItemDetailArgument arg = ModalRoute.of(context).settings.arguments;
      _item = arg.item;
      _amountController.text = _item.amount.toString();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _item.title,
          overflow: TextOverflow.fade,
        ),
      ),
      body: _item == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Title: ',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          _item.title,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Description: ',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          _item.description,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Amount: ',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Container(
                          width: 60,
                          height: 30,
                          child: Form(
                            child: TextFormField(
                              focusNode: _amountFocusNode,
                              controller: _amountController,
                              autofocus: false,
                              keyboardType: TextInputType.number,
                              enabled: !_showEditAmount,
                              style: const TextStyle(fontSize: 20),
                              onFieldSubmitted: (_) {
                                setState(() {
                                  _showEditAmount = true;
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                            height: 20,
                            child: _showEditAmount
                                ? IconButton(
                                    padding: const EdgeInsets.all(0.0),
                                    icon: const Icon(Icons.edit),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    onPressed: () {
                                      setState(() {
                                        _showEditAmount = false;
                                        Future.delayed(
                                            Duration(milliseconds: 60), () {
                                          FocusScope.of(context)
                                              .requestFocus(_amountFocusNode);
                                        });
                                      });
                                    },
                                  )
                                : IconButton(
                                    padding: const EdgeInsets.all(0.0),
                                    icon: const Icon(Icons.check_circle),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    onPressed: () {
                                      setState(() {
                                        _showEditAmount = true;
                                      });
                                    },
                                  )),
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Theme.of(context).colorScheme.primary,
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
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
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
