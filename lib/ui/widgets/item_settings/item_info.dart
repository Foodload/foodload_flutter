import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/models/item.dart';

class ItemInfo extends StatefulWidget {
  @override
  _ItemInfoState createState() => _ItemInfoState();
}

class _ItemInfoState extends State<ItemInfo> {
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  var _amountFocused = false;

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
  }

  TextEditingValue _getTextEditingValue(String value) {
    return TextEditingValue(
      text: value,
      selection: TextSelection.fromPosition(
        TextPosition(offset: value.length),
      ),
    );
  }

  void setFocus() {
    setState(() {
      _amountFocused = true;

      Future.delayed(Duration(milliseconds: 60), () {
        FocusScope.of(context).requestFocus(_amountFocusNode);
      });
    });
  }

  void _submit() {
    setState(() {
      _amountFocused = false;
    });
    print('submitted new amount');
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Make a listener to update amount when moving to other storages!
    return BlocBuilder<ItemSettingsBloc, ItemSettingsState>(
      builder: (context, state) {
        Item item = state.item;
        _amountController.value = _getTextEditingValue(item.amount.toString());
        return Column(
          children: <Widget>[
            _InformationRow('Title', item.title),
            _InformationRow('Description', item.description),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Amount: ',
                  style: const TextStyle(fontSize: 20),
                ),
                Container(
                  width: 60,
                  height: 30,
                  child: Form(
                    child: BlocBuilder<ItemSettingsBloc, ItemSettingsState>(
                      builder: (context, state) => TextFormField(
                        focusNode: _amountFocusNode,
                        controller: _amountController,
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        enabled: state is ItemSettingsDeleting
                            ? false
                            : _amountFocused,
                        style: const TextStyle(fontSize: 20),
                        onFieldSubmitted: (_) {
                          _submit();
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  child: BlocBuilder<ItemSettingsBloc, ItemSettingsState>(
                      builder: (context, state) => !_amountFocused
                          ? IconButton(
                              padding: const EdgeInsets.all(0.0),
                              icon: const Icon(Icons.edit),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: state is ItemSettingsDeleting
                                  ? null
                                  : setFocus,
                            )
                          : IconButton(
                              padding: const EdgeInsets.all(0.0),
                              icon: const Icon(Icons.check_circle),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: state is ItemSettingsDeleting
                                  ? null
                                  : _submit,
                            )),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}

class _InformationRow extends StatelessWidget {
  final String title;
  final String description;

  const _InformationRow(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '$title: $description',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        Divider(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ],
    );
  }
}
