import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/buy_list/buy_list.dart';
import 'package:foodload_flutter/helpers/snackbar_helper.dart';
import 'package:foodload_flutter/models/template.dart';
import 'package:foodload_flutter/ui/widgets/buy_item_widget.dart';
import 'package:foodload_flutter/ui/widgets/completable.dart';
import 'package:foodload_flutter/ui/widgets/refresher.dart';
import 'package:foodload_flutter/ui/widgets/scrollable_flexer.dart';

class BuyListScreen extends StatelessWidget {
  final Template template;

  const BuyListScreen(this.template);

  void _onRefresh(BuildContext context, Template template) {
    BlocProvider.of<BuyListBloc>(context)..add(GenerateBuyList(template, true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your buy list'),
      ),
      body: BlocConsumer<BuyListBloc, BuyListState>(
        listener: (context, state) {
          if (state is BuyListStateFail) {
            SnackBarHelper.showFailMessage(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is BuyListStateLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is BuyListStateSuccess) {
            return Refresher(
                onRefresh: () async => _onRefresh(context, template),
                child: state.itemsToBuy.length <= 0
                    ? ScrollableFlexer(
                        child: Center(
                          child: Text('Nothing here'),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.itemsToBuy.length,
                        itemBuilder: (ctx, index) {
                          final buyItem = state.itemsToBuy[index];
                          return Completable(
                            key: ValueKey(buyItem.itemInfo.id),
                            onDismiss: (direction) {
                              BlocProvider.of<BuyListBloc>(context)
                                  .add(RemoveBuyItem(buyItem));
                            },
                            child: BuyItemWidget(
                              buyItem: buyItem,
                            ),
                          );
                        },
                      ));
          } else {
            return Center(
              child: Text(':('),
            );
          }
        },
      ),
    );
  }
}
