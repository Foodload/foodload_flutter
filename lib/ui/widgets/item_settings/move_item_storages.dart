import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/helpers/keys.dart';
import 'package:foodload_flutter/helpers/snackbar_helper.dart';
import 'package:foodload_flutter/models/enums/action_error.dart';
import 'package:foodload_flutter/models/enums/status.dart';
import 'package:foodload_flutter/models/item.dart';

import 'move_item.dart';

class MoveItemStorages extends StatelessWidget {
  String _getActionErrorText(ItemSettingsState state) {
    switch (state.moveActionError) {
      case ActionError.Empty:
        return 'There is nothing to move';
      case ActionError.Overflow:
        return 'Storage is already full';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemSettingsBloc, ItemSettingsState>(
        listenWhen: (prevState, currState) =>
            prevState.moveStatus != currState.moveStatus,
        listener: (context, state) {
          if (state.moveStatus == Status.ERROR) {
            SnackBarHelper.showFailMessage(
              context,
              _getActionErrorText(state),
            );
          }
        },
        builder: (context, state) {
          Item item = state.item;
          return Column(
            children: <Widget>[
              if (item.storageType != fridge)
                MoveItem(
                  fridge,
                ),
              if (item.storageType != freezer)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: MoveItem(
                    freezer,
                  ),
                ),
              if (item.storageType != pantry)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: MoveItem(
                    pantry,
                  ),
                ),
            ],
          );
        });
  }
}
