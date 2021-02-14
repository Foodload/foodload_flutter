import 'package:foodload_flutter/models/item_info.dart';
import 'package:equatable/equatable.dart';

abstract class AddTemplateItemEvent extends Equatable {
  const AddTemplateItemEvent();

  @override
  List<Object> get props => [];
}

class ItemSelected extends AddTemplateItemEvent {
  final ItemInfo selectedItem;
  final int initAmount;

  const ItemSelected(this.selectedItem, this.initAmount);

  @override
  List<Object> get props => [selectedItem, initAmount];

  @override
  String toString() =>
      'ItemSelected { selectedItem: $selectedItem , initAmount: $initAmount}';
}

class ItemAmountChanged extends AddTemplateItemEvent {
  final int amount;
  final bool valid;

  const ItemAmountChanged({this.amount, this.valid});

  @override
  List<Object> get props => [amount, valid];

  @override
  String toString() => 'ItemAmountChanged {amount: $amount, valid: $valid}';
}

class ChangeItem extends AddTemplateItemEvent {
  @override
  String toString() => 'ChangeItem {}';
}

class AddTemplateItem extends AddTemplateItemEvent {
  final int templateId;

  const AddTemplateItem(this.templateId);

  @override
  String toString() => 'AddTemplateItem {templateId: $templateId}';
}
