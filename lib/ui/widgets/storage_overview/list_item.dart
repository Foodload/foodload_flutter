import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item/item.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/ui/screens/item_settings_screen.dart';
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

class ListItemDescription extends StatelessWidget {
  final String title;
  final String description;
  final int amount;

  const ListItemDescription({
    Key key,
    @required this.title,
    @required this.description,
    @required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 70,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.add,
                            size: 16,
                          ),
                        ),
                        TextSpan(
                          text: '$amount',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
