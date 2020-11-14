import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/item.dart';

abstract class ItemSettingsState extends Equatable {
  final Item item;
  const ItemSettingsState(this.item);

  @override
  List<Object> get props => [];
}

class ItemSettingsInit extends ItemSettingsState {
  ItemSettingsInit(Item item) : super(item);
}
