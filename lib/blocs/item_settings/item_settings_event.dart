import 'package:equatable/equatable.dart';

abstract class ItemSettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ItemSettingsUpdateAmount extends ItemSettingsEvent {
  final newAmount;

  ItemSettingsUpdateAmount(this.newAmount);

  @override
  String toString() => 'ItemSettingsUpdateAmount { newAmount: $newAmount }';
}

class ItemSettingsMoveToOtherStorage extends ItemSettingsEvent {
  final String storage;

  ItemSettingsMoveToOtherStorage(this.storage);

  @override
  String toString() => 'ItemSettingsMoveToOtherStorage { storage: $storage }';
}

class ItemSettingsMoveFromOtherStorage extends ItemSettingsEvent {
  final String storage;

  ItemSettingsMoveFromOtherStorage(this.storage);

  @override
  String toString() => 'ItemSettingsMoveFromOtherStorage { storage: $storage }';
}

class ItemSettingsDelete extends ItemSettingsEvent {
  @override
  String toString() => 'ItemSettingsDelete { }';
}

class ItemSettingsQueryDelete extends ItemSettingsEvent {
  @override
  String toString() => 'ItemSettingsQueryDelete { }';
}

class ItemSettingsSetInit extends ItemSettingsEvent {
  @override
  String toString() => 'ItemSettingsSetInit {  }';
}
