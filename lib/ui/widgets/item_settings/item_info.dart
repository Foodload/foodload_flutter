import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/helpers/snackbar_helper.dart';
import 'package:foodload_flutter/models/enums/field_error.dart';
import 'package:foodload_flutter/models/enums/status.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/ui/widgets/loading_dialog.dart';

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
    BlocProvider.of<ItemSettingsBloc>(context)
        .add(ItemSettingsUpdateAmount(_amountController.text));
  }

  String _getItemErrorText(ItemSettingsState state) {
    switch (state.itemStatus) {
      case Status.OUT_OF_DATE:
        return 'The item has been updated. Please take a look and try again.';
      default:
        return '';
    }
  }

  String _getAmountErrorText(ItemSettingsState state) {
    switch (state.amountError) {
      case FieldError.Invalid:
        return 'Amount must be an integer';
      case FieldError.AmountOverflow:
        return 'Amount is too high';
      case FieldError.NegativeAmount:
        return 'Amount must be greater than zero';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemSettingsBloc, ItemSettingsState>(
      listenWhen: (prevState, currState) =>
          (prevState.itemStatus != currState.itemStatus) ||
          (prevState.amountError != currState.amountError) ||
          (prevState.amountStatus != currState.amountStatus),
      listener: (context, state) {
        if (state.amountStatus == Status.LOADING) {
          BlocProvider.of<LoadingDialogBloc>(context).add(ShowDialog());
        } else {
          BlocProvider.of<LoadingDialogBloc>(context).add(HideDialog());
        }

        if (state.itemStatus == Status.OUT_OF_DATE) {
          SnackBarHelper.showFailMessage(
            context,
            _getItemErrorText(state),
          );
        } else if (state.amountStatus == Status.ERROR) {
          SnackBarHelper.showFailMessage(
            context,
            _getAmountErrorText(state),
          );
        }
      },
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
                        enabled: state.deleteStatus == Status.LOADING
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
                              onPressed: state.deleteStatus == Status.LOADING
                                  ? null
                                  : setFocus,
                            )
                          : IconButton(
                              padding: const EdgeInsets.all(0.0),
                              icon: const Icon(Icons.check_circle),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: state.deleteStatus == Status.LOADING
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
