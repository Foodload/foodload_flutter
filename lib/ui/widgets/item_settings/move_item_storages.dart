import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/helpers/keys.dart';
import 'package:foodload_flutter/models/item.dart';

import 'move_item.dart';

class MoveItemStorages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemSettingsBloc, ItemSettingsState>(
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
