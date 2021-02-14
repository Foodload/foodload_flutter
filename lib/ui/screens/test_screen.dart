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

  void addTemplate() async {
    Map<String, dynamic> body = {
      "name": "Template",
    };
    final res = await tempRepo.createTemplate(await userRepo.getToken(), body);
    print(res);
  }

  /*
  void updateTemplate() async {
    Map<String, dynamic> body = {
      "templateId": 8, //check
      "newTemplateItems": [
        {
          "itemId": 13,
          "count": 13,
        }
      ],
      "updatedTemplateItems": [
        {
          "templateItemId": 10, //check
          "count": 1337,
        }
      ],
    };
    final res = await tempRepo.updateTemplate(body, await userRepo.getToken());
    print(res);
  }
  */

  void addTemplateItem() async {
    Map<String, dynamic> body = {
      "itemId": 12,
      "count": 10,
    };
    //final res = await tempRepo.addTemplateItemToTemplate(
    //    await userRepo.getToken(), 13, body);
    //print(res);
  }

  void updateTemplateItem() async {
    // Map<String, dynamic> body = {
    //   "templateId": 12, //check
    //   "templateItemId": 16, //check
    //   "count": 1000,
    // };
    // final res =
    //     await tempRepo.updateTemplateItem(await userRepo.getToken(), body);
    // print(res);
  }

  void removeTemplateItem() async {
    // final res =
    //     await tempRepo.removeTemplateItem(await userRepo.getToken(), 12, 16);
    // print(res);
  }

  void deleteTemplate() async {
    await tempRepo.deleteTemplate(await userRepo.getToken(), 12);
  }

  void getBuyList() async {
    final res = await tempRepo.getBuyList(await userRepo.getToken(), 13);
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TEST API'),
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
              onPressed: addTemplate,
            ),
            RaisedButton(
              child: Text('ADD TEMPLATE ITEM'),
              onPressed: addTemplateItem,
            ),
            RaisedButton(
              child: Text('UPDATE TEMPLATE ITEM'),
              onPressed: updateTemplateItem,
            ),
            RaisedButton(
              child: Text('REMOVE TEMPLATE ITEM'),
              onPressed: removeTemplateItem,
            ),
            RaisedButton(
              child: Text('DELETE TEMPLATE'),
              onPressed: deleteTemplate,
            ),
            RaisedButton(
              child: Text('GET BUY LIST'),
              onPressed: getBuyList,
            ),
          ],
        ),
      ),
    );
  }
}
