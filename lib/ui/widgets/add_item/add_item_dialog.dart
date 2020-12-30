import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/add_item_form/add_item_form.dart';
import 'package:foodload_flutter/models/enums/status.dart';

class AddItemDialog extends StatelessWidget {
  final storageType;

  const AddItemDialog(this.storageType);

  bool _isAddSuccess(AddItemFormState state) =>
      state.addStatus == Status.COMPLETED;
  bool _isAdding(AddItemFormState state) => state.addStatus == Status.LOADING;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddItemFormBloc, AddItemFormState>(
        builder: (context, state) {
      if (_isAdding(state)) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return AlertDialog(
        title: Text(_isAddSuccess(state) ? 'Success' : 'Fail'),
        content: Text(_isAddSuccess(state)
            ? 'Successfully added ${state.item.title} to $storageType'
            : state.addErrorMessage ?? ''),
        actions: <Widget>[
          FlatButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    });
  }
}
