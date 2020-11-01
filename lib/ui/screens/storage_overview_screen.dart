import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/filtered_items/filtered_items.dart';
import 'package:foodload_flutter/blocs/items/items_bloc.dart';
import 'package:foodload_flutter/models/storage_overview_argument.dart';
import 'package:foodload_flutter/ui/widgets/storage_overview/storage_overview.dart';

class StorageOverviewScreen extends StatelessWidget {
  static const routeName = '/storage-overview-screen';

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context).settings.arguments as StorageOverviewArgument;

    return BlocProvider<FilteredItemsBloc>(
      create: (context) => FilteredItemsBloc(
          itemsBloc: BlocProvider.of<ItemsBloc>(context),
          storageType: argument.storageType),
      child: StorageOverview(
        title: argument.title,
        storageType: argument.storageType,
      ),
    );
  }
}
