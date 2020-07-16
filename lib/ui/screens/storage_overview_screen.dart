import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/filtered_items/filtered_items.dart';
import 'package:foodload_flutter/helpers/debouncer.dart';
import 'package:foodload_flutter/models/storage_overview_argument.dart';
import 'package:foodload_flutter/ui/screens/add_item_screen.dart';
import 'package:foodload_flutter/ui/widgets/list_item.dart';

class StorageOverviewScreen extends StatefulWidget {
  static const routeName = '/storage-overview';

  @override
  _StorageOverviewScreenState createState() => _StorageOverviewScreenState();
}

class _StorageOverviewScreenState extends State<StorageOverviewScreen> {
  var isSearching = false;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context).settings.arguments as StorageOverviewArgument;

    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text('${argument.title} Overview')
            : TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search for item',
                ),
                onChanged: (searchText) {
                  _debouncer.run(() {
                    BlocProvider.of<FilteredItemsBloc>(context)
                        .add(FilterUpdated(searchText));
                  });
                },
              ),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                    });
                    BlocProvider.of<FilteredItemsBloc>(context)
                        .add(FilterUpdated(""));
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),
          if (!isSearching)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddItemScreen.routeName);
              },
            ),
        ],
      ),
      body: BlocBuilder<FilteredItemsBloc, FilteredItemsState>(
        builder: (context, state) {
          if (state is FilteredItemsLoadInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is FilteredItemsLoadSuccess) {
            final filteredItems = state.filteredItems;
            return ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (ctx, index) => ListItem(
                itemRepresentation: filteredItems[index],
              ),
            );
          }

          return Text('Nope');
        },
      ),
    );
  }
}
