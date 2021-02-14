import 'package:flutter/material.dart';
import 'package:foodload_flutter/helpers/field_validation.dart';
import 'package:foodload_flutter/models/enums/field_error.dart';

class AmountSetter extends StatefulWidget {
  final TextEditingController amountTextController;
  final Function onValid;
  final Function onInvalid;
  final TextInputAction textFieldInputAction;

  const AmountSetter(
      {@required this.amountTextController,
      this.onValid,
      this.onInvalid,
      this.textFieldInputAction});

  @override
  AmountSetterState createState() => AmountSetterState();
}

class AmountSetterState extends State<AmountSetter> {
  TextEditingController _amountTextController;
  TextInputAction _textFieldInputAction;
  FieldError _amountError;
  Function _onValid;
  Function _onInvalid;

  @override
  void initState() {
    super.initState();
    _amountTextController = widget.amountTextController;
    _onInvalid = widget.onInvalid;
    _onValid = widget.onValid;
    _textFieldInputAction = widget.textFieldInputAction;
    _amountTextController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _amountTextController.removeListener(_onAmountChanged);
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
    var amount = int.tryParse(_amountTextController.text);
    if (amount == null) {
      return;
    }
    var newValue = (++amount).toString();
    _amountTextController.value = _getNewAmountValue(newValue);
  }

  void decrementAmount() {
    int amount = int.tryParse(_amountTextController.text);
    if (amount == null) {
      return;
    }
    var newValue = (--amount).toString();
    _amountTextController.value = _getNewAmountValue(newValue);
  }

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

  void _onAmountChanged() {
    final amountText = _amountTextController.text;
    if (amountText == null || amountText.isEmpty) {
      _setInvalidError(FieldError.Empty);
      return;
    }
    if (!FieldValidation.isInteger(amountText)) {
      _setInvalidError(FieldError.Invalid);
      return;
    }
    final amount = int.parse(amountText);

    if (FieldValidation.isAmountOverflow(amount)) {
      _setInvalidError(FieldError.AmountOverflow);
      return;
    }

    if (amount < 1) {
      _setInvalidError(FieldError.NegativeAmount);
      return;
    }

    if (_amountError != null) {
      setState(() {
        _amountError = null;
      });
    }

    if (_onValid != null) {
      _onValid(amount);
    }
  }

  void _setInvalidError(FieldError fieldError) {
    setState(() {
      _amountError = fieldError;
    });
    if (_onInvalid != null) {
      _onInvalid();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 100,
            child: Form(
              child: TextFormField(
                textInputAction: _textFieldInputAction ?? TextInputAction.none,
                controller: _amountTextController,
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                autocorrect: false,
                validator: (_) {
                  if (_amountError != null) {
                    return _amountErrorText(_amountError);
                  }
                  return null;
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (_amountError != FieldError.AmountOverflow)
                ? incrementAmount
                : null,
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: (_amountError != FieldError.NegativeAmount)
                ? decrementAmount
                : null,
          ),
        ],
      ),
    );
  }
}
