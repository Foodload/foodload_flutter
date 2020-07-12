import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item/bloc.dart';
import 'package:foodload_flutter/ui/widgets/list_item.dart';

class StorageOverviewScreen extends StatelessWidget {
  static const routeName = '/storage-overview';

  //Scanner
  Future scan() async {
    var options = ScanOptions(
      strings: {
        "cancel": _cancelController.text,
        "flash_on": _flashOnController.text,
        "flash_off": _flashOffController.text,
      },
    );
    ScanResult result = await BarcodeScanner.scan(
      options: options,
    );
    print(result.rawContent);
  }

  final _flashOnController = TextEditingController(text: "Flash on");
  final _flashOffController = TextEditingController(text: "Flash off");
  final _cancelController = TextEditingController(text: "Cancel");

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context).settings.arguments as String;
    //final _itemBloc = BlocProvider.of<ItemBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('$title Overview'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: scan,
          ),
        ],
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
