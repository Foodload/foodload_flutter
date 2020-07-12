import 'package:foodload_flutter/models/item_representation.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final ItemRepresentation itemRepresentation;

  final _show = true;

  const ListItem({
    Key key,
    @required this.itemRepresentation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Card(
        child: InkWell(
          onTap: () {
            print('Click!');
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: _show
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://static.mathem.se/shared/images/products/medium/07310865001825_g1l1.jpeg.jpg'),
                          )
                        : Icon(
                            Icons.image,
                          ),
                  ),
                  ListItemDescription(
                    title: itemRepresentation.title,
                    description: itemRepresentation.description,
                    amount: itemRepresentation.items.length,
                  ),
                ],
              ),
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
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 2.0),
                  ),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'ICA',
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.add,
                            size: 15,
                          ),
                        ),
                        TextSpan(text: '$amount'),
                        WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                        ),
                        WidgetSpan(
                          child: Icon(
                            Icons.date_range,
                            size: 15,
                          ),
                        ),
                        TextSpan(text: '2020-07-05'),
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
