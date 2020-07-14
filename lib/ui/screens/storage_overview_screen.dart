import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/filtered_items/filtered_items.dart';
import 'package:foodload_flutter/helpers/debouncer.dart';
import 'package:foodload_flutter/ui/widgets/list_item_representation.dart';

class StorageOverviewScreen extends StatefulWidget {
  static const routeName = '/storage-overview';

  @override
  _StorageOverviewScreenState createState() => _StorageOverviewScreenState();
}

class _StorageOverviewScreenState extends State<StorageOverviewScreen> {
  var isSearching = false;
  final _debouncer = Debouncer(milliseconds: 500);

  Future scan() async {
    var options = ScanOptions(
      strings: {
        "cancel": "Cancel",
        "flash_on": "Flash on",
        "flash_off": "Flash off",
      },
    );
    ScanResult result = await BarcodeScanner.scan(
      options: options,
    );
    print(result.rawContent);
  }

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text('$title Overview')
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
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: scan,
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
              itemBuilder: (ctx, index) => ListItemRepresentation(
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
