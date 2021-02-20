import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:meta/meta.dart';

@immutable
class BuyItem extends Equatable {
  final ItemInfo itemInfo;
  final int amount;

  const BuyItem(this.itemInfo, this.amount);

  @override
  List<Object> get props => [itemInfo, amount];

  @override
  String toString() => 'BuyItem {itemInfo: $itemInfo, amount: $amount}';

  BuyItem.fromJson(Map<String, dynamic> json)
      : itemInfo = ItemInfo.fromJson(json['item']),
        amount = json['amount'];
}
