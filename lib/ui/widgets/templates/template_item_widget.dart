import 'package:flutter/material.dart';
import 'package:foodload_flutter/models/template_item.dart';
import 'package:foodload_flutter/ui/widgets/list_item_description.dart';

class TemplateItemWidget extends StatelessWidget {
  final TemplateItem templateItem;
  final DismissDirectionCallback onDismiss;
  final Function increment;
  final Function decrement;

  TemplateItemWidget({
    @required this.templateItem,
    @required this.onDismiss,
    @required this.increment,
    @required this.decrement,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(templateItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30.0,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      onDismissed: onDismiss,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListItemDescription(
                  title: templateItem.itemInfo.title,
                  description: templateItem.itemInfo.brand,
                  amount: templateItem.count,
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: increment,
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: decrement,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
