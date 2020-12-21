import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/item.dart';

abstract class ItemSettingsState extends Equatable {
  final Item item;
  final String message = null;
  const ItemSettingsState(this.item);

  @override
  List<Object> get props => [];
}

class ItemSettingsInit extends ItemSettingsState {
  ItemSettingsInit(Item item) : super(item);
}

class ItemSettingsDeleteSuccess extends ItemSettingsState {
  final String message;
  ItemSettingsDeleteSuccess(Item item, this.message) : super(item);

  @override
  List<Object> get props => [item, message];

  @override
  String toString() {
    return 'ItemSettingsDeleteSuccess { item: $item, message: $message }';
  }
}

class ItemSettingsDeleteFail extends ItemSettingsState {
  final String message;
  ItemSettingsDeleteFail(Item item, this.message) : super(item);

  @override
  List<Object> get props => [item, message];

  @override
  String toString() {
    return 'ItemSettingsDeleteFail { item: $item, message: $message }';
  }
}

class ItemSettingsDeleting extends ItemSettingsState {
  ItemSettingsDeleting(Item item) : super(item);

  @override
  String toString() {
    return 'ItemSettingsDeleting { item: $item }';
  }
}

class ItemSettingsLoading extends ItemSettingsState {
  ItemSettingsLoading(Item item) : super(item);

  @override
  String toString() {
    return 'ItemSettingsLoading { item: $item }';
  }
}

class ItemSettingsMoveFinish extends ItemSettingsState {
  ItemSettingsMoveFinish(Item item) : super(item);

  @override
  String toString() {
    return 'ItemSettingsMoveFinish { item: $item }';
  }

  @override
  List<Object> get props => [item];
}
