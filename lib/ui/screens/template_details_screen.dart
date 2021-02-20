import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/add_template_item/add_template_item.dart';
import 'package:foodload_flutter/blocs/buy_list/buy_list.dart';
import 'package:foodload_flutter/blocs/template/template.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/template_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/helpers/navigator_helper.dart';
import 'package:foodload_flutter/helpers/snackbar_helper.dart';
import 'package:foodload_flutter/models/enums/status.dart';
import 'package:foodload_flutter/models/template.dart';
import 'package:foodload_flutter/models/template_item.dart';
import 'package:foodload_flutter/ui/screens/add_template_item_screen.dart';
import 'package:foodload_flutter/ui/screens/buy_list_screen.dart';
import 'package:foodload_flutter/ui/widgets/deleting_snackbar.dart';
import 'package:foodload_flutter/ui/widgets/templates/template_item_widget.dart';

class TemplateDetailsScreen extends StatelessWidget {
  void _confirmDelete(BuildContext context, Template template) async {
    final delete = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to remove this template?'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                FlatButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ));
    if (delete == true) {
      Navigator.of(context).pop(template);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TemplateBloc, TemplateState>(
      listener: (context, state) {
        if (state.status == Status.ERROR) {
          SnackBarHelper.showFailMessage(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is TemplateStateLoading) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state.template == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('Could not show template'),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(state.template.name),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.receipt),
                  onPressed: () => NavigatorHelper.push(
                    context: context,
                    child: BlocProvider<BuyListBloc>(
                      create: (context) => BuyListBloc(
                        userRepository:
                            RepositoryProvider.of<UserRepository>(context),
                        itemRepository:
                            RepositoryProvider.of<ItemRepository>(context),
                        templateRepository:
                            RepositoryProvider.of<TemplateRepository>(context),
                      )..add(
                          GenerateBuyList(state.template, false),
                        ),
                      child: BuyListScreen(state.template),
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _confirmDelete(context, state.template),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              final templateItemToAdd = await NavigatorHelper.push(
                context: context,
                child: BlocProvider<AddTemplateItemBloc>(
                  create: (context) => AddTemplateItemBloc(
                    templateRepository:
                        RepositoryProvider.of<TemplateRepository>(context),
                    userRepository:
                        RepositoryProvider.of<UserRepository>(context),
                  ),
                  child: AddTemplateItemScreen(state.template.id),
                ),
              );
              if (templateItemToAdd != null) {
                BlocProvider.of<TemplateBloc>(context).add(TemplateItemAdded());
              }
            },
          ),
          body: TemplateDetailsBody(),
        );
      },
    );
  }
}

class TemplateDetailsBody extends StatelessWidget {
  void _showDeleteTemplateItemSnackBar(
      BuildContext context, int templateItemId) {
    Scaffold.of(context)
        .showSnackBar(
          DeletingSnackBar(
            context: context,
            message: 'Deleting item...',
            onUndo: () {
              BlocProvider.of<TemplateBloc>(context)
                  .add(UndoDeleteTemplateItem());
            },
          ),
        )
        .closed
        .then((SnackBarClosedReason reason) {
      if (reason != SnackBarClosedReason.action) {
        //Then we haven't pressed undo; delete template item
        BlocProvider.of<TemplateBloc>(context)
            .add(DeleteTemplateItem(templateItemId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TemplateBloc, TemplateState>(
      builder: (context, state) {
        if (state.template.templateItems.length <= 0) {
          return Center(
            child: Text('Empty'),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 3.0),
            itemCount: state.template.templateItems.length,
            itemBuilder: (ctx, index) {
              final TemplateItem templateItem =
                  state.template.templateItems[index];
              return TemplateItemWidget(
                templateItem: templateItem,
                onDismiss: (direction) {
                  BlocProvider.of<TemplateBloc>(context)
                      .add(DeleteTemplateItemFromState(templateItem.id));
                  _showDeleteTemplateItemSnackBar(context, templateItem.id);
                },
                decrement: () => BlocProvider.of<TemplateBloc>(context).add(
                    UpdateTemplateItem(
                        templateItem.id, templateItem.count - 1)),
                increment: () => BlocProvider.of<TemplateBloc>(context).add(
                    UpdateTemplateItem(
                        templateItem.id, templateItem.count + 1)),
              );
            },
          );
        }
      },
    );
  }
}
