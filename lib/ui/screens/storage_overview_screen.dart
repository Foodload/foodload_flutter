import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item/bloc.dart';
import 'package:foodload_flutter/ui/widgets/list_item.dart';

class StorageOverviewScreen extends StatelessWidget {
  static const routeName = '/storage-overview';

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context).settings.arguments as String;
    //final _itemBloc = BlocProvider.of<ItemBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('$title Overview'),
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ItemSuccess) {
            return ListView.builder(
              itemCount: state.itemRepresentations.length,
              itemBuilder: (ctx, index) => ListItem(
                itemRepresentation: state.itemRepresentations[index],
              ),
            );
          }

          return Text('Nope');
        },
      ),
    );
  }
}
