import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/models/enums/status.dart';

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

  String _getStatusText(ItemSettingsState state) {
    switch (state.deleteStatus) {
      case Status.COMPLETED:
        return 'Successfully deleted the item';
      case Status.ERROR:
        return 'Could not delete the item. Please try again.';
      default:
        return '';
    }
  }

  Widget _result() {
    return BlocBuilder<ItemSettingsBloc, ItemSettingsState>(
        builder: (context, state) {
      if (state.deleteStatus == Status.LOADING) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return AlertDialog(
        title:
            Text(state.deleteStatus == Status.COMPLETED ? 'Success' : 'Fail'),
        content: Text(_getStatusText(state)),
        actions: <Widget>[
          FlatButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context)
                  .pop(state.deleteStatus == Status.COMPLETED ? true : false);
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
