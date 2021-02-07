import 'package:foodload_flutter/models/template.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class TemplateListItem extends StatelessWidget {
  final Template template;
  final DismissDirectionCallback onDismiss;
  final GestureTapCallback onTap;

  const TemplateListItem({
    Key key,
    @required this.template,
    @required this.onDismiss,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(template.id),
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
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text('Do you want to remove this item?'),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    ),
                  ],
                ));
      },
      direction: DismissDirection.endToStart,
      onDismissed: onDismiss,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Hero(
                tag: '${template.id}__heroTag',
                child: Container(
                  width: double.infinity,
                  child: Text(
                    template.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
