import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';

class DeleteItemDialog extends StatefulWidget {
  @override
  _DeleteItemDialogState createState() => _DeleteItemDialogState();
}

class _DeleteItemDialogState extends State<DeleteItemDialog> {
  var queryingDelete = true;

  Widget _initQuery() {
    return AlertDialog(
      title: Text('Are you sure you want to delete this?'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              setState(() {
                queryingDelete = false;
              });
              BlocProvider.of<ItemSettingsBloc>(context)
                  .add(ItemSettingsDelete());
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Widget _result() {
    return BlocBuilder<ItemSettingsBloc, ItemSettingsState>(
        builder: (context, state) {
      if (state is ItemSettingsDeleting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return AlertDialog(
        title: Text(state is ItemSettingsDeleteSuccess ? 'Success' : 'Fail'),
        content: Text(state.message),
        actions: <Widget>[
          FlatButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context)
                  .pop(state is ItemSettingsDeleteSuccess ? true : false);
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return (queryingDelete ? _initQuery() : _result());
  }
}
