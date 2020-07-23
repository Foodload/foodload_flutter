import 'package:foodload_flutter/models/item_info.dart';
import 'package:meta/meta.dart';

@immutable
class AddItemFormState {
  //Item to be added
  final ItemInfo item;

  //Search
  final bool isSearching;
  final bool isSearchFail;
  final bool isSearchSuccess;

  //ID and amount field
  final bool isItemIdEntered;
  final bool isItemAmountEntered;
  final bool isItemAmountNumber;
  final bool isItemAmountAtLeastOne;
  final bool isItemAmountLimitReached;

  bool get isFormValid =>
      (item != null) &&
      isItemAmountNumber &&
      isItemAmountAtLeastOne &&
      !isItemAmountLimitReached;

  AddItemFormState({
    @required this.item,
    @required this.isSearching,
    @required this.isSearchFail,
    @required this.isSearchSuccess,
    @required this.isItemIdEntered,
    @required this.isItemAmountEntered,
    @required this.isItemAmountNumber,
    @required this.isItemAmountAtLeastOne,
    @required this.isItemAmountLimitReached,
  });

  factory AddItemFormState.initial() {
    return AddItemFormState(
      item: null,
      isSearching: false,
      isSearchSuccess: false,
      isSearchFail: false,
      isItemIdEntered: false,
      isItemAmountEntered: true, //init to 1
      isItemAmountNumber: true,
      isItemAmountAtLeastOne: true,
      isItemAmountLimitReached: false,
    );
  }

  AddItemFormState update({
    ItemInfo item,
    bool isSearching,
    bool isSearchSuccess,
    bool isSearchFail,
    bool isItemIdEntered,
    bool isItemAmountEntered,
    bool isItemAmountNumber,
    bool isItemAmountAtLeastOne,
    bool isItemAmountLimitReached,
  }) {
    return copyWith(
      item: item,
      isSearching: isSearching,
      isSearchSuccess: isSearchSuccess,
      isSearchFail: isSearchFail,
      isItemIdEntered: isItemIdEntered,
      isItemAmountEntered: isItemAmountEntered,
      isItemAmountNumber: isItemAmountNumber,
      isItemAmountAtLeastOne: isItemAmountAtLeastOne,
      isItemAmountLimitReached: isItemAmountLimitReached,
    );
  }

  AddItemFormState copyWith({
    ItemInfo item,
    bool isSearching,
    bool isSearchSuccess,
    bool isSearchFail,
    bool isItemIdEntered,
    bool isItemAmountEntered,
    bool isItemAmountNumber,
    bool isItemAmountAtLeastOne,
    bool isItemAmountLimitReached,
  }) {
    return AddItemFormState(
      item: item ?? this.item,
      isSearching: isSearching ?? this.isSearching,
      isSearchSuccess: isSearchSuccess ?? this.isSearchSuccess,
      isSearchFail: isSearchFail ?? this.isSearchFail,
      isItemIdEntered: isItemIdEntered ?? this.isItemIdEntered,
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
      item: $item,
      isSearching: $isSearching,
      isSearchSuccess: $isSearchSuccess,
      isSearchFail: $isSearchFail,
      isItemIdEntered: $isItemIdEntered,
      isItemAmountEntered: $isItemAmountEntered,
      isItemAmountNumber: $isItemAmountNumber,
      isItemAmountAtLeastOne: $isItemAmountAtLeastOne,
      isItemAmountLimitReached: $isItemAmountLimitReached,
    }''';
  }
}
