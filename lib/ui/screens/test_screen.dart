import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/template_repository.dart';
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
  TemplateRepository tempRepo;

  @override
  void initState() {
    super.initState();
    userRepo = RepositoryProvider.of<UserRepository>(context);
    itemRepo = RepositoryProvider.of<ItemRepository>(context);
    tempRepo = RepositoryProvider.of<TemplateRepository>(context);
  }

  void getTemplates() async {
    final res = await tempRepo.getTemplates();
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD ITEMS'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('GET TEMPLATES'),
              onPressed: getTemplates,
            ),
            RaisedButton(
              child: Text('ADD TEMPLATE'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
