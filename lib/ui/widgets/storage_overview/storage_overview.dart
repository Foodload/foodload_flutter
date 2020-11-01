import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/filtered_items/filtered_items.dart';
import 'package:foodload_flutter/models/add_item_argument.dart';
import 'package:foodload_flutter/ui/screens/add_item_screen.dart';
import 'package:foodload_flutter/ui/widgets/storage_overview/storage_overview_body.dart';

class StorageOverview extends StatefulWidget {
  final String title;
  final String storageType;

  const StorageOverview({this.title, this.storageType});

  @override
  _StorageOverviewState createState() => _StorageOverviewState();
}

class _StorageOverviewState extends State<StorageOverview> {
  var isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text('${widget.title} Overview')
            : TextField(
                autofocus: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search for item',
                ),
                onChanged: (searchText) {
                  BlocProvider.of<FilteredItemsBloc>(context)
                      .add(FilterUpdated(searchText));
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
                Navigator.of(context).pushNamed(
                  AddItemScreen.routeName,
                  arguments: AddItemArgument(
                    storageType: widget.storageType,
                  ),
                );
              },
            ),
        ],
      ),
      body: StorageOverviewBody(),
    );
  }
}
