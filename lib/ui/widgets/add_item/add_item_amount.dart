import 'package:flutter/material.dart';

class AddItemAmount extends StatefulWidget {
  final Function amountHandler;

  const AddItemAmount(this.amountHandler);

  @override
  _AddItemAmountState createState() => _AddItemAmountState();
}

class _AddItemAmountState extends State<AddItemAmount> {
  final initValue = 1;
  var _textController;
  var _isNegativeOrZero = false;
  var _isInteger = true;
  var _invalidAmountText;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(_checkValidAmount);
    _textController.text = initValue.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  bool _checkIsInteger() {
    var amount = int.tryParse(_textController.text);
    return amount != null;
  }

  void _checkValidAmount() {
    if (!_checkIsInteger()) {
      setState(() {
        _invalidAmountText = 'Must be a number';
        _isInteger = false;
      });
      widget.amountHandler(null);
      return;
    }

    int amount = int.parse(_textController.text);
    if (amount < 1) {
      setState(() {
        _invalidAmountText = 'Must be at least 1';
        _isInteger = true;
        _isNegativeOrZero = true;
      });
      widget.amountHandler(null);
      return;
    }

    setState(() {
      _invalidAmountText = null;
      _isNegativeOrZero = false;
      _isInteger = true;
    });
    widget.amountHandler(amount);
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
    if (_checkIsInteger()) {
      var amount = int.parse(_textController.text);
      var newValue = (++amount).toString();
      _textController.value = _getNewAmountValue(newValue);
    }
  }

  void decrementAmount() {
    if (_checkIsInteger()) {
      int amount = int.parse(_textController.text);
      if (amount == 1) {
        return;
      }
      var newValue = (--amount).toString();
      _textController.value = _getNewAmountValue(newValue);
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
            child: TextField(
              controller: _textController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  errorText:
                      _invalidAmountText == null ? null : _invalidAmountText),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _isInteger ? incrementAmount : null,
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed:
                _isInteger ? _isNegativeOrZero ? null : decrementAmount : null,
          ),
        ],
      ),
    );
  }
}
