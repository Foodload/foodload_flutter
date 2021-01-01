import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/ui/widgets/item_settings/delete_item.dart';
import 'package:foodload_flutter/ui/widgets/item_settings/item_info.dart';
import 'package:foodload_flutter/ui/widgets/item_settings/move_item_storages.dart';
import 'package:foodload_flutter/ui/widgets/loading_dialog.dart';

class ItemSettingsScreen extends StatefulWidget {
  static const routeName = '/item-settings';

  @override
  _ItemSettingsScreenState createState() => _ItemSettingsScreenState();
}

class _ItemSettingsScreenState extends State<ItemSettingsScreen> {
  final LoadingDialogBloc _dialogBloc = LoadingDialogBloc();

  @override
  void dispose() {
    super.dispose();
    _dialogBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    final _itemSettingsBloc = ModalRoute.of(context).settings.arguments;

    return MultiBlocProvider(
      providers: [
        BlocProvider<ItemSettingsBloc>.value(value: _itemSettingsBloc),
        BlocProvider<LoadingDialogBloc>.value(
          value: _dialogBloc,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Item settings',
            overflow: TextOverflow.fade,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                LoadingDialog(_dialogBloc),
                Column(
                  children: <Widget>[
                    ItemInfo(),
                    Divider(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MoveItemStorages(),
                  ],
                ),
                SizedBox(
                  height: 70,
                ),
                DeleteItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
