import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/add_item_form/add_item_form.dart';
import 'package:foodload_flutter/helpers/snackbar_helper.dart';
import 'package:foodload_flutter/models/enums/status.dart';
import 'package:foodload_flutter/ui/widgets/add_item/add_item_amount.dart';
import 'package:foodload_flutter/ui/widgets/add_item/add_item_dialog.dart';
import 'package:foodload_flutter/ui/widgets/add_item/add_item_info.dart';
import 'package:foodload_flutter/ui/widgets/add_item/add_item_search_options.dart';

class AddItemForm extends StatefulWidget {
  final storageType;

  const AddItemForm(this.storageType);

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

  Future<void> _showAddDialog() async {
    return showDialog(
      context: context,
      builder: (_) => BlocProvider<AddItemFormBloc>.value(
        value: _addItemFormBloc,
        child: AddItemDialog(widget.storageType),
      ),
    );
  }

  void _resetForm() {
    _itemIdTextController.text = '';
    _itemAmountTextController.text = _initAmountValue.toString();
  }

  void _addItem() async {
    _addItemFormBloc.add(ItemAdd(
        amount: _itemAmountTextController.text,
        storageType: widget.storageType));
    await _showAddDialog(); //TODO: If failed, return false and don't reset?
    _addItemFormBloc.add(AddItemFormReset());
    _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        BlocConsumer<AddItemFormBloc, AddItemFormState>(
          listener: (context, state) {
            if (state.searchStatus == Status.ERROR) {
              SnackBarHelper.showFailMessage(
                context,
                state.searchErrorMessage,
              );
            }
          },
          builder: (context, state) {
            if (state.searchStatus == Status.LOADING) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Column(
              children: <Widget>[
                if (state.item != null)
                  AddItemInfo(
                    title: state.item.title,
                    brand: state.item.brand,
                    changeHandler: _changeItem,
                  ),
                if (state.item == null)
                  AddItemSearchOptions(_itemIdTextController),
                AddItemAmount(_itemAmountTextController),
              ],
            );
          },
        ),
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
            onPressed: state.isFormValid ? _addItem : null,
          ),
        ),
      ],
    );
  }
}
