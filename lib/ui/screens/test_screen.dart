import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/template_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/helpers/snackbar_helper.dart';

//TODO: Remove
class TestScreen extends StatefulWidget {
  static const routeName = '/test-screen';

  TestScreen();

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  UserRepository userRepo;
  ItemRepository itemRepo;
  TemplateRepository tempRepo;

  final qrController = TextEditingController();
  final nameController = TextEditingController();
  final brandController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userRepo = RepositoryProvider.of<UserRepository>(context);
    itemRepo = RepositoryProvider.of<ItemRepository>(context);
    tempRepo = RepositoryProvider.of<TemplateRepository>(context);
  }

  Future _scan() async {
    var options = ScanOptions(
      strings: {
        'cancel': 'Cancel',
        'flash_on': 'Flash on',
        'flash_off': 'Flash off',
      },
    );
    ScanResult result = await BarcodeScanner.scan(
      options: options,
    );

    if (result.type == ResultType.Barcode) {
      _onScanned(result.rawContent);
    } else {
      SnackBarHelper.showFailMessage(context,
          "Sorry, we don't currently support this type of scan. Please try to type in the ID.");
    }
  }

  void _onScanned(String qr) {
    if (qr.trim().length == 0) return;
    setState(() {
      qrController.text = qr;
    });
  }

  void _reset() {
    setState(() {
      qrController.text = '';
      nameController.text = '';
      brandController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD ITEMS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'QR',
                      ),
                      controller: qrController,
                    ),
                  ),
                  RaisedButton(
                    onPressed: _scan,
                    child: Text('Scan'),
                  )
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
                controller: nameController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Brand',
                ),
                controller: brandController,
              ),
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                child: Text('ADD ITEM'),
                onPressed: () async {
                  final qr = qrController.text;
                  final name = nameController.text;
                  final brand = brandController.text;
                  if (qr.isEmpty || name.isEmpty || brand.isEmpty) return;
                  await itemRepo.addItemToDb(
                    token: await userRepo.getToken(),
                    qr: qr,
                    name: name,
                    brand: brand,
                  );
                  _reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
