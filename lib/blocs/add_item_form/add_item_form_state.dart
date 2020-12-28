import 'package:foodload_flutter/models/enums/field_error.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:meta/meta.dart';

@immutable
class AddItemFormState {
  final ItemInfo item;

  final bool isAdding;
  final bool addSuccess;
  final bool isSearching;
  final bool searchSuccess;
  final FieldError amountError;
  final FieldError itemIdError;
  bool get isFormValid =>
      item != null && amountError == null && itemIdError == null;

  AddItemFormState({
    this.isAdding: false,
    this.addSuccess,
    this.isSearching: false,
    this.searchSuccess,
    this.amountError,
    this.itemIdError,
    this.item,
  });

  AddItemFormState copyWith(
      {bool isAdding,
      bool addSuccess,
      bool isSearching,
      bool searchSuccess,
      FieldError amountError,
      FieldError itemIdError,
      ItemInfo item}) {
    return AddItemFormState(
      isAdding: isAdding ?? this.isAdding,
      addSuccess: addSuccess ?? this.addSuccess,
      isSearching: isSearching ?? this.isSearching,
      searchSuccess: searchSuccess ?? this.searchSuccess,
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
      isAdding: $isAdding,
      addSuccess: $addSuccess,
      item: $item,
      isSearching: $isSearching,
      searchSuccess: $searchSuccess,
      amountError: $amountError,
      itemIdError: $itemIdError
    }''';
  }
}
