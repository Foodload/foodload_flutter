import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/helpers/error_handler/model/status.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:foodload_flutter/models/template_item.dart';
import 'package:meta/meta.dart';

@immutable
class AddTemplateItemState extends Equatable {
  final ItemInfo item;
  final int amount;
  final bool validAmount;
  final Status addStatus;

  bool get isFormValid => item != null && amount != null && validAmount;

  AddTemplateItemState(
      {this.item, this.amount, this.validAmount, this.addStatus: Status.INIT});

  AddTemplateItemState copyWith({
    ItemInfo item,
    int amount,
    bool validAmount,
    Status addStatus,
  }) {
    return AddTemplateItemState(
      item: item ?? this.item,
      amount: amount ?? this.amount,
      validAmount: validAmount ?? this.validAmount,
      addStatus: addStatus ?? this.addStatus,
    );
  }

  @override
  String toString() {
    return 'AddTemplateItemState {item: $item, amount: $amount, validAmount: $validAmount}, addStatus: $addStatus';
  }

  @override
  List<Object> get props => [item, amount, validAmount, addStatus];
}

class AddTemplateItemSuccess extends AddTemplateItemState {
  final TemplateItem templateItem;

  AddTemplateItemSuccess(this.templateItem);
}

class AddTemplateItemFail extends AddTemplateItemState {
  final String errorMsg;

  AddTemplateItemFail(this.errorMsg);
}
