import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings_bloc.dart';
import 'package:foodload_flutter/models/enums/status.dart';
import 'package:foodload_flutter/ui/widgets/item_settings/delete_item_dialog.dart';

class DeleteItem extends StatefulWidget {
  @override
  _DeleteItemState createState() => _DeleteItemState();
}

class _DeleteItemState extends State<DeleteItem> {
  ItemSettingsBloc _itemSettingsBloc;
  StreamSubscription _itemSettingsSub;

  @override
  void initState() {
    super.initState();
    _itemSettingsBloc = BlocProvider.of<ItemSettingsBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    if (_itemSettingsSub != null) {
      _itemSettingsSub.cancel();
    }
  }

  bool _isDeleting(ItemSettingsState state) =>
      state.deleteStatus == Status.LOADING;

  Future<void> _showDeleteItemDialog() async {
    _itemSettingsBloc.add(ItemSettingsQueryDelete());
    final shouldPop = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => BlocProvider<ItemSettingsBloc>.value(
              value: _itemSettingsBloc,
              child: WillPopScope(
                onWillPop: () async => false,
                child: DeleteItemDialog(),
              ),
            ));
    if (_itemSettingsBloc.state.deleteStatus == Status.COMPLETED) {
      Navigator.of(context).pop();
      return;
    }

    /* User has dismissed before loading has finished, set a listener*/
    // if (_isDeleting(_itemSettingsBloc.state) && shouldPop == null) {
    //   _itemSettingsSub = _itemSettingsBloc.listen((state) {
    //     if (state.deleteStatus == Status.COMPLETED) {
    //       Navigator.of(context).pop();
    //     }
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BlocBuilder<ItemSettingsBloc, ItemSettingsState>(
        builder: (context, state) => RaisedButton(
          color: Theme.of(context).colorScheme.error,
          child: _isDeleting(state)
              ? SizedBox(
                  height: 18,
                  width: 18,
                  child: Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )),
                )
              : Text(
                  'Delete',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
          onPressed: _isDeleting(state) ? null : _showDeleteItemDialog,
        ),
      ),
    );
  }
}
