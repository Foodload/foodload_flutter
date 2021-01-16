import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';

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

  @override
  void initState() {
    super.initState();
    userRepo = RepositoryProvider.of<UserRepository>(context);
    itemRepo = RepositoryProvider.of<ItemRepository>(context);
  }

  void addItem() async {
    itemRepo.addItem(
        qr: '7310865875020',
        amount: 1,
        token: await userRepo.getToken(),
        storageType: 'Fridge');
  }

  void removeItem() async {
    //itemRepo.removeItem(await userRepo.getToken(), '7310865062024', fridge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TEST'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('ADD'),
              onPressed: addItem,
            ),
            RaisedButton(
              child: Text('REMOVE'),
              onPressed: removeItem,
            ),
            RaisedButton(child: Text('CHECKFRIDGE'), onPressed: null),
          ],
        ),
      ),
    );
  }
}
