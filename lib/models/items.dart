import 'dart:async';

import 'package:foodload_flutter/models/item.dart';

///Holds all the items for this application and has all the necessary manipulation functions.
///
///Provides a stream to listen for updates to the items.
class Items {
  List<Item> _items = [];
  final _itemsController = StreamController<List<Item>>();
  final _itemController = StreamController<Item>();

  Stream<List<Item>> get itemsStream => _itemsController.stream;

  Stream<Item> get itemStream => _itemController.stream;

  Items(List<Item> items) : _items = items;

  List<Item> get items => [..._items];

  Item getItem(int id) {
    final idx = _items.indexWhere((item) => item.id == id);
    if (idx == -1) return null;
    return _items.elementAt(idx).copyWith();
  }

  ///Replaces the items with the given newItems
  void setItems(List<Item> newItems) {
    _items = newItems;
    _updateItemsListeners();
  }

  ///Delete the item with the given id from items
  void deleteItem(int id) {
    final idx = _items.indexWhere((item) => item.id == id);
    if (idx != -1) {
      _items.removeAt(idx);
      _updateItemsListeners();
    }
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
      _updateItemsListeners();
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
      _updateItemsListeners();
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
    _updateItemsListeners();
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
    _updateItemsListeners();
  }

  ///Updates all the listeners by sending the updated items through its stream
  void _updateItemsListeners() {
    _itemsController.sink.add([..._items]);
  }

  ///Updates all the listeners by sending the updated single item through its stream
  void _updateItemListener(Item updatedItem) {
    _itemController.sink.add(updatedItem);
  }

  void dispose() {
    _itemsController.close();
    _itemController.close();
  }
}
