import 'package:foodload_flutter/models/enums/field_error.dart';
import 'package:foodload_flutter/models/enums/status.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:meta/meta.dart';

@immutable
class AddItemFormState {
  final ItemInfo item;

  final Status addStatus;
  final String addErrorMessage;
  final Status searchStatus;
  final String searchErrorMessage;
  final FieldError amountError;
  final FieldError itemIdError;
  bool get isFormValid =>
      item != null && amountError == null && itemIdError == null;

  AddItemFormState({
    this.addStatus: Status.READY,
    this.addErrorMessage,
    this.searchStatus: Status.READY,
    this.searchErrorMessage,
    this.amountError,
    this.itemIdError,
    this.item,
  });

  AddItemFormState copyWith(
      {Status addStatus,
      String addErrorMessage,
      Status searchStatus,
      String searchErrorMessage,
      FieldError amountError,
      FieldError itemIdError,
      ItemInfo item}) {
    return AddItemFormState(
      addStatus: addStatus ?? this.addStatus,
      addErrorMessage: addErrorMessage ?? this.addErrorMessage,
      searchStatus: searchStatus ?? this.searchStatus,
      searchErrorMessage: searchErrorMessage ?? this.searchErrorMessage,
      amountError: amountError ?? this.amountError,
      itemIdError: itemIdError ?? this.itemIdError,
      item: item ?? this.item,
    );
  }

  AddItemFormState amountValid() {
    return AddItemFormState(
      itemIdError: this.itemIdError,
      item: this.item,
    );
  }

  AddItemFormState itemIdValid() {
    return AddItemFormState(
      amountError: this.amountError,
      item: this.item,
    );
  }

  AddItemFormState changeItem() {
    return AddItemFormState(
      amountError: this.amountError,
    );
  }

  @override
  String toString() {
    return '''AddItemFormState {
      item: $item,
      addStatus: $addStatus,
      addErrorMessage: $addErrorMessage,
      searchStatus: $searchStatus,
      searchErrorMessage: $searchErrorMessage,
      amountError: $amountError,
      itemIdError: $itemIdError
    }''';
  }
}
