import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/item.dart';

class ItemRepresentation extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<Item> items;

  const ItemRepresentation({this.id, this.title, this.description, this.items});

  @override
  List<Object> get props => [id, title, description];

  @override
  String toString() =>
      'ItemRepresentation { id: $id, title: $title, description: $description, items: $items }';
}
