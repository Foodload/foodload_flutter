import 'package:flutter/material.dart';
import 'package:foodload_flutter/models/buy_item.dart';
import 'package:foodload_flutter/ui/widgets/list_item_description.dart';

class BuyItemWidget extends StatelessWidget {
  final BuyItem buyItem;

  const BuyItemWidget({this.buyItem}) : assert(buyItem != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListItemDescription(
                title: buyItem.itemInfo.title,
                description: buyItem.itemInfo.brand,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.add,
                  size: 32,
                  semanticLabel: 'Amount of the item to buy',
                ),
              ),
              Text(
                '${buyItem.amount}',
                style: TextStyle(fontSize: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
