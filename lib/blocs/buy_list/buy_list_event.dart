import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/buy_item.dart';
import 'package:foodload_flutter/models/template.dart';

abstract class BuyListEvent extends Equatable {
  const BuyListEvent();

  @override
  List<Object> get props => [];
}

class GenerateBuyList extends BuyListEvent {
  final Template template;
  final bool eagerFetch;

  const GenerateBuyList(this.template, this.eagerFetch);

  @override
  String toString() =>
      'GenerateBuyList {eagerFetch: $eagerFetch, template: $template}';
}

class RemoveBuyItem extends BuyListEvent {
  final BuyItem buyItem;

  const RemoveBuyItem(this.buyItem);

  @override
  String toString() => 'RemoveBuyItem {buyItem: $buyItem}';
}
