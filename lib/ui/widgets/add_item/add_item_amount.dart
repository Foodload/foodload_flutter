import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/add_item_form/add_item_form.dart';
import 'package:foodload_flutter/models/enums/field_error.dart';

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

  @override
  void dispose() {
    super.dispose();
    _itemAmountTextController.removeListener(_onItemAmountChanged);
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

  bool _hasAmountError(AddItemFormState state) => state.amountError != null;

  String _amountErrorText(FieldError error) {
    switch (error) {
      case FieldError.Empty:
        return 'Cannot be empty';
      case FieldError.Invalid:
        return 'Must be an integer';
      case FieldError.AmountOverflow:
        return 'Too big';
      case FieldError.NegativeAmount:
        return 'Too small';
      default:
        return '';
    }
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
                  autovalidateMode: AutovalidateMode.always,
                  autocorrect: false,
                  validator: (_) {
                    if (_hasAmountError(state)) {
                      return _amountErrorText(state.amountError);
                    }
                    return null;
                  },
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: (state.amountError != FieldError.AmountOverflow)
                  ? incrementAmount
                  : null,
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: (state.amountError != FieldError.NegativeAmount)
                  ? decrementAmount
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
