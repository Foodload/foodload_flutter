import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/filtered_items/filtered_items_bloc.dart';
import 'package:foodload_flutter/blocs/filtered_items/filtered_items_state.dart';
import 'package:foodload_flutter/blocs/item/item_bloc.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/ui/widgets/storage_overview/list_item.dart';

class StorageOverviewBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredItemsBloc, FilteredItemsState>(
      builder: (context, state) {
        if (state is FilteredItemsLoadInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final filteredItems = (state as FilteredItemsLoadSuccess).filteredItems;
        return BlocProvider<ItemBloc>(
          create: (context) {
            return ItemBloc(
              userRepository: RepositoryProvider.of<UserRepository>(context),
              itemRepository: RepositoryProvider.of<ItemRepository>(context),
            );
          },
          child: ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (ctx, index) => ListItem(
              item: filteredItems[index],
            ),
          ),
        );
      },
    );
  }
}
