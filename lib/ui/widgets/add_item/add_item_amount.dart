import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/add_item_form/add_item_form.dart';

class AddItemAmount extends StatefulWidget {
  final TextEditingController _itemAmountTextController;

  const AddItemAmount(this._itemAmountTextController);

  @override
  _AddItemAmountState createState() => _AddItemAmountState();
}

class _AddItemAmountState extends State<AddItemAmount> {
  var _itemAmountTextController;
  AddItemFormBloc _addItemFormBloc;

  @override
  void initState() {
    super.initState();
    _addItemFormBloc = BlocProvider.of<AddItemFormBloc>(context);
    _itemAmountTextController = widget._itemAmountTextController;
    _itemAmountTextController.addListener(_onItemAmountChanged);
  }

  void _onItemAmountChanged() {
    _addItemFormBloc
        .add(ItemAmountChanged(amount: _itemAmountTextController.text));
  }

  TextEditingValue _getNewAmountValue(String newValue) {
    return TextEditingValue(
      text: newValue,
      selection: TextSelection.fromPosition(
        TextPosition(offset: newValue.length),
      ),
    );
  }

  void incrementAmount() {
    var amount = int.tryParse(_itemAmountTextController.text);
    if (amount == null) {
      return;
    }
    var newValue = (++amount).toString();
    _itemAmountTextController.value = _getNewAmountValue(newValue);
  }

  void decrementAmount() {
    int amount = int.tryParse(_itemAmountTextController.text);
    if (amount == null) {
      return;
    }
    var newValue = (--amount).toString();
    _itemAmountTextController.value = _getNewAmountValue(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: BlocBuilder<AddItemFormBloc, AddItemFormState>(
        builder: (context, state) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              child: Form(
                child: TextFormField(
                  controller: _itemAmountTextController,
                  keyboardType: TextInputType.number,
                  autovalidate: true,
                  autocorrect: false,
                  validator: (_) {
                    if (!state.isItemAmountEntered) {
                      return "Enter a number";
                    } else if (!state.isItemAmountNumber) {
                      return "Must be a number";
                    } else if (state.isItemAmountLimitReached) {
                      return "Max is 999";
                    } else if (!state.isItemAmountAtLeastOne) {
                      return "Must be at least 1";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed:
                  (state.isItemAmountNumber && !state.isItemAmountLimitReached)
                      ? incrementAmount
                      : null,
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed:
                  (state.isItemAmountNumber && state.isItemAmountAtLeastOne)
                      ? decrementAmount
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
