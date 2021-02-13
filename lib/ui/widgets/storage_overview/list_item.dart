import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item/item.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/ui/screens/item_settings_screen.dart';
import 'package:foodload_flutter/ui/widgets/list_item_description.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final Item item;

  const ListItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      key: ValueKey(item.id),
      borderRadius: BorderRadius.circular(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListItemDescription(
                  title: item.title,
                  description: item.description,
                  amount: item.amount,
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    BlocProvider.of<ItemBloc>(context)
                        .add(ItemIncrement(item.id));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    BlocProvider.of<ItemBloc>(context)
                        .add(ItemDecrement(item.id));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    final userRepo =
                        RepositoryProvider.of<UserRepository>(context);
                    final itemRepo =
                        RepositoryProvider.of<ItemRepository>(context);
                    // ignore: close_sinks
                    final bloc = ItemSettingsBloc(
                        userRepository: userRepo,
                        itemRepository: itemRepo,
                        item: item);
                    Navigator.of(context).pushNamed(
                      ItemSettingsScreen.routeName,
                      arguments: bloc,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
