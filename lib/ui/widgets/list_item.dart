import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/models/item_detail_argument.dart';
import 'package:foodload_flutter/ui/screens/item_detail_screen.dart';
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
                  onPressed: () {},
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      ItemDetailScreen.routeName,
                      arguments: ItemDetailArgument(
                        item: item,
                      ),
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

//class ListItem extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return ClipRRect(
//      borderRadius: BorderRadius.circular(10),
//      child: Card(
//        child: ListTile(
//          title: Text('Milk'),
//          leading: CircleAvatar(
//            backgroundImage: NetworkImage(
//                'https://static.mathem.se/shared/images/products/medium/07310865001825_g1l1.jpeg.jpg'),
//          ),
//          trailing: Container(
//            width: 100,
//            child: Row(
//              children: <Widget>[
//                IconButton(
//                  color: Theme.of(context).colorScheme.primary,
//                  splashColor: Theme.of(context).colorScheme.primary,
//                  icon: Icon(Icons.edit),
//                  onPressed: () {},
//                ),
//                IconButton(
//                  color: Theme.of(context).colorScheme.primary,
//                  splashColor: Theme.of(context).colorScheme.primary,
//                  icon: Icon(Icons.info),
//                  onPressed: () {},
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
