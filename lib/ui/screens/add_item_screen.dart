import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/add_item_form/add_item_form.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/ui/widgets/add_item/add_item_form.dart';

class AddItemScreen extends StatefulWidget {
  static const routeName = '/add-item';

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add item'),
      ),
      body: SingleChildScrollView(
        child: BlocProvider<AddItemFormBloc>(
          create: (context) {
            final userRepository =
                RepositoryProvider.of<UserRepository>(context);
            final itemRepository =
                RepositoryProvider.of<ItemRepository>(context);
            return AddItemFormBloc(
              itemRepository: itemRepository,
              userRepository: userRepository,
            );
          },
          child: AddItemForm(),
        ),
      ),
    );
  }
}
