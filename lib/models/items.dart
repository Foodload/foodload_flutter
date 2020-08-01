import 'dart:async';

import 'package:foodload_flutter/models/item.dart';

///Holds all the items for this application and has all the necessary manipulation functions.
///
///Provides a stream to listen for updates to the items.
class Items {
  List<Item> _items = [];
  final _controller = StreamController<List<Item>>();

  Items();

  Stream<List<Item>> get stream => _controller.stream;

  ///Updates the items with the given newItems
  void updateItems(List<Item> newItems) {
    _items = newItems;
    _updateListeners();
  }

  ///Deletes the item with the given id from items
  void deleteItem(String id) {
    final idx = _items.indexWhere((item) => item.id == id);
    if (idx != -1) {
      _items.removeAt(idx);
      _updateListeners();
    }
  }

  ///Adds newItem to items
  void addItem(Item newItem) {
    _items.add(newItem);
    _updateListeners();
  }

  ///Increments the item with the given id with the given increment
  void incrementItemAmount(String id, int increment) {
    final idx = _items.indexWhere((item) => item.id == id);
    if (idx != -1) {
      final oldItem = _items.elementAt(idx);
      var amount = oldItem.amount;
      amount += increment;
      _items.removeAt(idx);
      _items.insert(idx, oldItem.copyWith(amount: amount));
      _updateListeners();
    }
  }

  ///Decrements the item with the given id with the given decrement
  void decrementItemAmount(String id, int decrement) {
    final idx = _items.indexWhere((item) => item.id == id);
    if (idx != -1) {
      final oldItem = _items.elementAt(idx);
      var amount = oldItem.amount;
      amount -= decrement;
      if (amount < 0) amount = 0;
      _items.removeAt(idx);
      _items.insert(idx, oldItem.copyWith(amount: amount));
      _updateListeners();
    }
  }

  ///Updates the item by replacing it with the new item
  void updateItem(Item newItem) {
    final idx = _items.indexWhere((item) => item.id == newItem.id);
    if (idx != -1) {
      _items.removeAt(idx);
      _items.insert(idx, newItem);
      _updateListeners();
    }
  }

  ///Updates all the listeners by sending the updated items through its stream
  void _updateListeners() {
    _controller.sink.add([..._items]);
  }

  void dispose() {
    _controller.close();
  }
}
