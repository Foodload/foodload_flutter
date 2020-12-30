import 'dart:async';

import 'package:foodload_flutter/models/item.dart';

///Holds all the items for this application and has all the necessary manipulation functions.
///
///Provides a stream to listen for updates to the items.
class Items {
  List<Item> _items = [];
  final _controller = StreamController<List<Item>>();

  Stream<List<Item>> get stream => _controller.stream;

  Items(List<Item> items) : _items = items;

  List<Item> get items => [..._items];

  ///Replaces the items with the given newItems
  void setItems(List<Item> newItems) {
    _items = newItems;
    _updateListeners();
  }

  ///Delete the item with the given id from items
  void deleteItem(int id) {
    final idx = _items.indexWhere((item) => item.id == id);
    if (idx != -1) {
      _items.removeAt(idx);
      _updateListeners();
    }
  }

  ///Add newItem to items
  void addItem(Item newItem) {
    _items.add(newItem);
    _updateListeners();
  }

  ///Increment the item with the given id with the given increment
  void incrementItemAmount(int id, int increment) {
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

  ///Decrement the item with the given id with the given decrement
  void decrementItemAmount(int id, int decrement) {
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

  ///Update the item by replacing it with the new item
  void updateWithItem(Item newItem) {
    final itemIdx = _items.lastIndexWhere((item) => item.id == newItem.id);
    if (itemIdx == -1) {
      _items.add(newItem);
    } else {
      _items.removeAt(itemIdx);
      _items.insert(itemIdx, newItem);
    }
    _updateListeners();
  }

  ///Update the item by replacing it with the new items
  void updateWithItems(List<Item> newItems) {
    newItems.forEach((newItem) {
      final itemIdx = _items.lastIndexWhere((item) => item.id == newItem.id);
      if (itemIdx == -1) {
        _items.add(newItem);
      } else {
        _items.removeAt(itemIdx);
        _items.insert(itemIdx, newItem);
      }
    });
    _updateListeners();
  }

  ///Updates all the listeners by sending the updated items through its stream
  void _updateListeners() {
    _controller.sink.add([..._items]);
  }

  void dispose() {
    _controller.close();
  }
}
