import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/item_representation.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemInitial extends ItemState {}

class ItemSendInProgress extends ItemState {}

class ItemSendSuccess extends ItemState {}

class ItemSendFailure extends ItemState {}

//Prob specify fridge, freezer, pantry etc.
class ItemSuccess extends ItemState {
  final List<ItemRepresentation> itemRepresentations;

  const ItemSuccess({
    this.itemRepresentations,
  });

  ItemSuccess copyWith({
    List<ItemRepresentation> itemRepresentations,
  }) {
    return ItemSuccess(
      itemRepresentations: itemRepresentations ?? this.itemRepresentations,
    );
  }

  @override
  List<Object> get props => [itemRepresentations];

  @override
  String toString() =>
      'ItemSuccess { itemRepresentations: ${itemRepresentations.length} }';
}

class ItemFailure extends ItemState {}
