import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/enums/action_error.dart';
import 'package:foodload_flutter/models/enums/field_error.dart';
import 'package:foodload_flutter/models/enums/status.dart';
import 'package:foodload_flutter/models/item.dart';

class ItemSettingsState extends Equatable {
  final Item item;
  final Status itemStatus;
  final FieldError amountError;
  final Status amountStatus;
  final ActionError moveActionError;
  final Status moveStatus;

  final Status deleteStatus;

  ItemSettingsState({
    this.item,
    this.itemStatus: Status.READY,
    this.amountError,
    this.amountStatus: Status.READY,
    this.moveActionError,
    this.moveStatus: Status.READY,
    this.deleteStatus: Status.READY,
  });

  @override
  List<Object> get props => [
        item,
        itemStatus,
        amountError,
        amountStatus,
        moveActionError,
        moveStatus,
        deleteStatus,
      ];

  ItemSettingsState copyWith({
    Item item,
    Status itemStatus,
    FieldError amountError,
    Status amountStatus,
    ActionError moveActionError,
    Status moveStatus,
    Status deleteStatus,
  }) {
    return ItemSettingsState(
      item: item ?? this.item,
      itemStatus: itemStatus,
      amountError: amountError,
      amountStatus: amountStatus,
      moveActionError: moveActionError,
      moveStatus: moveStatus,
      deleteStatus: deleteStatus,
    );
  }

  @override
  String toString() {
    return '''ItemSettingsState 
    {
    item: $item ,
    itemStatus: $itemStatus,
    amountError: $amountError, 
    amountStatus: $amountStatus,
    moveActionError: $moveActionError,
    moveStatus: $moveStatus
    }
    ''';
  }
}
