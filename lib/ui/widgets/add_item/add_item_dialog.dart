import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/add_item_form/add_item_form.dart';

class AddItemDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddItemFormBloc, AddItemFormState>(
        builder: (context, state) {
      if (state.isAdding) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return AlertDialog(
        title: Text(state.isAddSuccess ? 'Success' : 'Fail'),
        content: Text(state.isAddSuccess
            ? 'Successfully added ${state.item.title} to storage!'
            : 'Failed to add item. Please try again later'),
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
