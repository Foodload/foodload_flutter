import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/models/enums/status.dart';

class MoveItem extends StatelessWidget {
  final String otherStorage;

  const MoveItem(this.otherStorage);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        BlocBuilder<ItemSettingsBloc, ItemSettingsState>(
          builder: (context, state) => IconButton(
            icon: const Icon(Icons.remove_circle),
            color: Theme.of(context).colorScheme.primary,
            onPressed: state.deleteStatus == Status.LOADING
                ? null
                : () => {
                      BlocProvider.of<ItemSettingsBloc>(context)
                          .add(ItemSettingsMoveFromOtherStorage(otherStorage))
                    },
          ),
        ),
        Container(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Move to ',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                otherStorage,
                style: TextStyle(
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<ItemSettingsBloc, ItemSettingsState>(
          builder: (context, state) => IconButton(
            icon: const Icon(Icons.add_circle),
            color: Theme.of(context).colorScheme.primary,
            onPressed: state.deleteStatus == Status.LOADING
                ? null
                : () => {
                      BlocProvider.of<ItemSettingsBloc>(context)
                          .add(ItemSettingsMoveToOtherStorage(otherStorage))
                    },
          ),
        ),
      ],
    );
  }
}
