import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/buy_item.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BuyListState extends Equatable {
  @override
  List<Object> get props => [];
}

class BuyListStateSuccess extends BuyListState {
  final List<BuyItem> itemsToBuy;

  BuyListStateSuccess(this.itemsToBuy);

  @override
  String toString() {
    return 'BuyListStateSuccess {itemsToBuy: $itemsToBuy}';
  }

  @override
  List<Object> get props => [this.itemsToBuy];
}

class BuyListStateLoading extends BuyListState {
  @override
  String toString() {
    return 'BuyListStateLoading {}';
  }
}

class BuyListStateFail extends BuyListState {
  final String message;

  BuyListStateFail(this.message);

  @override
  String toString() {
    return 'BuyListStateFail {}';
  }
}
