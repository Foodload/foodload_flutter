import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/add_item_form/add_item_form.dart';
import 'package:foodload_flutter/ui/widgets/add_item/add_item_amount.dart';
import 'package:foodload_flutter/ui/widgets/add_item/add_item_info.dart';
import 'package:foodload_flutter/ui/widgets/add_item/add_item_search_options.dart';

class AddItemForm extends StatefulWidget {
  @override
  _AddItemFormState createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _initAmountValue = 1;
  final _itemIdTextController = TextEditingController();
  final _itemAmountTextController = TextEditingController();
  AddItemFormBloc _addItemFormBloc;

  @override
  void initState() {
    super.initState();
    _addItemFormBloc = BlocProvider.of<AddItemFormBloc>(context);
    _itemAmountTextController.text = _initAmountValue.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _itemIdTextController.dispose();
    _itemAmountTextController.dispose();
  }

  void _changeItem() {
    _itemIdTextController.text = '';
    _addItemFormBloc.add(ItemChange());
  }

  void showSnackBar(String title) {}

  void printInfo() {
    print(_itemIdTextController.text);
    print(_itemAmountTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddItemFormBloc, AddItemFormState>(
      listener: (context, state) {
        if (state.isFormValid) {
          //_itemId = state.itemId;
          //_itemAmount = state.itemAmount;
        }
      },
      child: Column(
        children: <Widget>[
          BlocConsumer<AddItemFormBloc, AddItemFormState>(
            listener: (context, state) {
              if (state.isSearchFail) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: Text(
                        'Could not find item with the given ID.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                    ),
                  );
              }
            },
            builder: (context, state) {
              if (state.isSearching) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state.isItemValid) {
                return AddItemInfo(
                  title: state.item.title,
                  changeHandler: _changeItem,
                );
              } else {
                return AddItemSearchOptions(_itemIdTextController);
              }
            },
          ),
          AddItemAmount(_itemAmountTextController),
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<AddItemFormBloc, AddItemFormState>(
            builder: (context, state) => RaisedButton(
              color: Theme.of(context).colorScheme.secondary,
              child: Text(
                'Add',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              onPressed: state.isFormValid ? printInfo : null,
            ),
          ),
        ],
      ),
    );
  }
}
