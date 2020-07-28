import 'dart:async';

import 'package:foodload_flutter/models/item.dart';

class Items {
  List<Item> _items = [];
  final _controller = StreamController<List<Item>>();

  Items();

  Stream<List<Item>> get stream => _controller.stream;

  void updateItems(List<Item> newItems) {
    _items = newItems;
    _controller.sink.add([..._items]);
  }

  void dispose() {
    _controller.close();
  }
}
