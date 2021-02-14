import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/add_template_item/add_template_item.dart';
import 'package:foodload_flutter/blocs/add_template_item/add_template_item_bloc.dart';
import 'package:foodload_flutter/blocs/search_item/search_item_bloc.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:foodload_flutter/ui/screens/search_item_screen.dart';
import 'package:foodload_flutter/ui/widgets/add_item/add_item_info.dart';
import 'package:foodload_flutter/ui/widgets/amount_setter.dart';

class AddTemplateItemScreen extends StatefulWidget {
  final int templateId;

  const AddTemplateItemScreen(this.templateId);

  @override
  _AddTemplateItemScreenState createState() => _AddTemplateItemScreenState();
}

class _AddTemplateItemScreenState extends State<AddTemplateItemScreen> {
  ItemInfo selectedItem;
  final _itemAmountTextController = TextEditingController();

  void setSelectedItem(selectedItem) {
    setState(() {
      this.selectedItem = selectedItem;
    });
  }

  void changeSelectedItem() {
    setState(() {
      this.selectedItem = null;
    });
  }

  void _resetItemAmount(int initAmount) {
    _itemAmountTextController.text = initAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTemplateItemBloc, AddTemplateItemState>(
      listener: (context, state) {
        if (state is AddTemplateItemSuccess) {
          Navigator.of(context).pop(state.templateItem);
        }
      },
      builder: (context, state) {
        if (state.item == null) {
          return BlocProvider<SearchItemBloc>(
            create: (context) => SearchItemBloc(
              itemRepository: RepositoryProvider.of<ItemRepository>(context),
              userRepository: RepositoryProvider.of<UserRepository>(context),
            ),
            child: SearchItemScreen(
              onSelect: (itemInfo) {
                BlocProvider.of<AddTemplateItemBloc>(context)
                    .add(ItemSelected(itemInfo, 1));
                _resetItemAmount(1);
              },
            ),
          );
        }
        //_resetItemAmount();
        return Scaffold(
          appBar: AppBar(
            title: Text('Add to template'),
          ),
          body: Center(
            child: Column(
              children: [
                AddItemInfo(
                  title: state.item.title,
                  brand: state.item.brand,
                  changeHandler: () =>
                      BlocProvider.of<AddTemplateItemBloc>(context)
                          .add(ChangeItem()),
                ),
                AmountSetter(
                  amountTextController: _itemAmountTextController,
                  onInvalid: () => BlocProvider.of<AddTemplateItemBloc>(context)
                      .add(ItemAmountChanged(valid: false)),
                  onValid: (int amount) =>
                      BlocProvider.of<AddTemplateItemBloc>(context)
                          .add(ItemAmountChanged(amount: amount, valid: true)),
                ),
                const SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  onPressed: state.isFormValid
                      ? () => BlocProvider.of<AddTemplateItemBloc>(context).add(
                            AddTemplateItem(widget.templateId),
                          )
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
