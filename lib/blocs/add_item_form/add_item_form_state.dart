import 'package:foodload_flutter/models/item_info.dart';
import 'package:meta/meta.dart';

@immutable
class AddItemFormState {
  //Add
  final bool isAdding;
  final bool isAddSuccess;
  final bool isAddFail;

  //Item to be added
  final ItemInfo item;

  //Search
  final bool isSearching;
  final bool isSearchFail;
  final bool isSearchSuccess;
  final String failMessage;

  //Amount field
  final bool isItemAmountEntered;
  final bool isItemAmountNumber;
  final bool isItemAmountAtLeastOne;
  final bool isItemAmountLimitReached;

  //Id field
  final bool isItemIdEntered;

  bool get isFormValid =>
      item != null &&
      isItemIdEntered &&
      isItemAmountNumber &&
      isItemAmountAtLeastOne &&
      isItemAmountEntered &&
      !isItemAmountLimitReached;

  AddItemFormState({
    @required this.isAdding,
    @required this.isAddSuccess,
    @required this.isAddFail,
    @required this.item,
    @required this.isItemIdEntered,
    @required this.isSearching,
    @required this.isSearchFail,
    @required this.isSearchSuccess,
    @required this.failMessage,
    @required this.isItemAmountEntered,
    @required this.isItemAmountNumber,
    @required this.isItemAmountAtLeastOne,
    @required this.isItemAmountLimitReached,
  });

  factory AddItemFormState.initial() {
    return AddItemFormState(
      isAdding: false,
      isAddSuccess: false,
      isAddFail: false,
      item: null,
      isItemIdEntered: false,
      isSearching: false,
      isSearchSuccess: false,
      isSearchFail: false,
      isItemAmountEntered: true, //init to 1
      isItemAmountNumber: true,
      isItemAmountAtLeastOne: true,
      isItemAmountLimitReached: false,
    );
  }

  AddItemFormState changeItem() {
    return AddItemFormState(
      isAdding: isAdding ?? this.isAdding,
      isAddSuccess: isAddSuccess ?? this.isAddSuccess,
      isAddFail: isAddFail ?? this.isAddFail,
      item: null,
      isItemIdEntered: false,
      isSearching: isSearching ?? this.isSearching,
      isSearchSuccess: isSearchSuccess ?? this.isSearchSuccess,
      isSearchFail: isSearchFail ?? this.isSearchFail,
      failMessage: failMessage ?? this.failMessage,
      isItemAmountEntered: isItemAmountEntered ?? this.isItemAmountEntered,
      isItemAmountNumber: isItemAmountNumber ?? this.isItemAmountNumber,
      isItemAmountAtLeastOne:
          isItemAmountAtLeastOne ?? this.isItemAmountAtLeastOne,
      isItemAmountLimitReached:
          isItemAmountLimitReached ?? this.isItemAmountLimitReached,
    );
  }

  AddItemFormState adding() {
    return copyWith(
      isAdding: true,
      isAddSuccess: false,
      isAddFail: false,
    );
  }

  AddItemFormState addSuccess() {
    return copyWith(
      isAdding: false,
      isAddSuccess: true,
      isAddFail: false,
    );
  }

  AddItemFormState addFail() {
    return copyWith(
      isAdding: false,
      isAddSuccess: false,
      isAddFail: true,
    );
  }

  AddItemFormState searchLoading() {
    return copyWith(
      isSearching: true,
      isSearchSuccess: false,
      isSearchFail: false,
    );
  }

  AddItemFormState searchFailure(failMsg) {
    return copyWith(
        isSearching: false,
        isSearchSuccess: false,
        isSearchFail: true,
        failMessage: failMsg);
  }

  AddItemFormState searchSuccess(ItemInfo itemInfo) {
    return copyWith(
      isSearching: false,
      isSearchSuccess: true,
      isSearchFail: false,
      item: itemInfo,
      isItemValid: true,
    );
  }

  AddItemFormState update({
    ItemInfo item,
    bool isItemValid,
    bool isItemIdEntered,
    bool isItemAmountEntered,
    bool isItemAmountNumber,
    bool isItemAmountAtLeastOne,
    bool isItemAmountLimitReached,
  }) {
    return copyWith(
      isAdding: false,
      isAddSuccess: false,
      isAddFail: false,
      item: item,
      isItemValid: isItemValid,
      isSearching: false,
      isSearchSuccess: false,
      isSearchFail: false,
      isItemIdEntered: isItemIdEntered,
      isItemAmountEntered: isItemAmountEntered,
      isItemAmountNumber: isItemAmountNumber,
      isItemAmountAtLeastOne: isItemAmountAtLeastOne,
      isItemAmountLimitReached: isItemAmountLimitReached,
    );
  }

  AddItemFormState copyWith({
    bool isAdding,
    bool isAddSuccess,
    bool isAddFail,
    ItemInfo item,
    bool isItemValid,
    bool isSearching,
    bool isSearchSuccess,
    bool isSearchFail,
    String failMessage,
    bool isItemIdEntered,
    bool isItemAmountEntered,
    bool isItemAmountNumber,
    bool isItemAmountAtLeastOne,
    bool isItemAmountLimitReached,
  }) {
    return AddItemFormState(
      isAdding: isAdding ?? this.isAdding,
      isAddSuccess: isAddSuccess ?? this.isAddSuccess,
      isAddFail: isAddFail ?? this.isAddFail,
      item: item ?? this.item,
      isItemIdEntered: isItemIdEntered ?? this.isItemIdEntered,
      isSearching: isSearching ?? this.isSearching,
      isSearchSuccess: isSearchSuccess ?? this.isSearchSuccess,
      isSearchFail: isSearchFail ?? this.isSearchFail,
      failMessage: failMessage ?? this.failMessage,
      isItemAmountEntered: isItemAmountEntered ?? this.isItemAmountEntered,
      isItemAmountNumber: isItemAmountNumber ?? this.isItemAmountNumber,
      isItemAmountAtLeastOne:
          isItemAmountAtLeastOne ?? this.isItemAmountAtLeastOne,
      isItemAmountLimitReached:
          isItemAmountLimitReached ?? this.isItemAmountLimitReached,
    );
  }

  @override
  String toString() {
    return '''AddItemFormState {
      isAdding: $isAdding,
      isAddSuccess: $isAddSuccess,
      isAddFail: $isAddFail,
      item: $item,
      isItemIdEntered: $isItemIdEntered,
      isSearching: $isSearching,
      isSearchSuccess: $isSearchSuccess,
      isSearchFail: $isSearchFail,
      isItemAmountEntered: $isItemAmountEntered,
      isItemAmountNumber: $isItemAmountNumber,
      isItemAmountAtLeastOne: $isItemAmountAtLeastOne,
      isItemAmountLimitReached: $isItemAmountLimitReached,
    }''';
  }
}
