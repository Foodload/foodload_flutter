import 'dart:async';
import 'dart:collection';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/template_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/helpers/error_handler/core/error_handler.dart';
import 'package:foodload_flutter/helpers/error_handler/model/exceptions.dart';
import 'package:foodload_flutter/models/buy_item.dart';
import 'package:foodload_flutter/models/exceptions/api_exception.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/models/items.dart';
import 'package:meta/meta.dart';

import 'buy_list.dart';

class BuyListBloc extends Bloc<BuyListEvent, BuyListState> {
  final UserRepository _userRepository;
  final ItemRepository _itemRepository;
  final TemplateRepository _templateRepository;

  BuyListBloc({
    @required userRepository,
    @required itemRepository,
    @required templateRepository,
  })  : assert(
          userRepository != null &&
              itemRepository != null &&
              templateRepository != null,
        ),
        _userRepository = userRepository,
        _itemRepository = itemRepository,
        _templateRepository = templateRepository,
        super(BuyListStateLoading());

  @override
  Stream<BuyListState> mapEventToState(BuyListEvent event) async* {
    if (event is GenerateBuyList) {
      yield* _mapGenerateBuyListToState(event);
    } else if (event is RemoveBuyItem) {
      yield* _mapRemoveBuyItemToState(event);
    }
  }

  Stream<BuyListState> _mapRemoveBuyItemToState(RemoveBuyItem event) async* {
    try {
      final updatedBuyList = (state as BuyListStateSuccess)
          .itemsToBuy
          .where((buyItem) => buyItem.itemInfo != event.buyItem.itemInfo)
          .toList();
      print(updatedBuyList);
      yield BuyListStateSuccess(updatedBuyList);
    } catch (error, stackTrace) {
      ErrorHandler.reportCheckedError(
          SilentLogException(error.message), stackTrace);
      yield BuyListStateFail(
          'Something went wrong and a message has been sent to our developers. Please try again later.');
    }
  }

  Stream<BuyListState> _mapGenerateBuyListToState(
      GenerateBuyList event) async* {
    try {
      Items items = _itemRepository.items();
      if (items == null || event.eagerFetch) {
        final List<BuyItem> itemsToBuy = await _templateRepository.getBuyList(
          await _userRepository.getToken(),
          event.template.id,
        );
        yield BuyListStateSuccess(itemsToBuy);
      } else {
        final List<Item> listItems = items.items;
        HashMap<String, int> itemCountsMap = HashMap();
        listItems.forEach((item) {
          itemCountsMap.update(item.qrCode, (value) => value + item.amount,
              ifAbsent: () => item.amount);
        });

        final List<BuyItem> itemsToBuy = List();
        event.template.templateItems.forEach((templateItem) {
          final itemCount = itemCountsMap[templateItem.itemInfo.qrCode];
          if (itemCount == null) {
            itemsToBuy.add(BuyItem(templateItem.itemInfo, templateItem.count));
          } else {
            final balance = templateItem.count -
                itemCountsMap[templateItem.itemInfo.qrCode];
            if (balance > 0) {
              itemsToBuy.add(BuyItem(templateItem.itemInfo, balance));
            }
          }
        });

        yield BuyListStateSuccess(itemsToBuy);
      }
    } on ApiException catch (apiException) {
      yield BuyListStateFail(
        apiException.getMessage() ?? apiException.getPrefix(),
      );
    } catch (error, stackTrace) {
      ErrorHandler.reportCheckedError(
          SilentLogException(error.message), stackTrace);
      yield BuyListStateFail(
          'Something went wrong and a message has been sent to our developers. Please try again later.');
    }
  }
}
