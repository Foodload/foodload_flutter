import 'package:flutter/material.dart';
import 'package:foodload_flutter/data/providers/foodload_api_client.dart';
import 'package:foodload_flutter/data/providers/socket_service.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:foodload_flutter/models/items.dart';
import 'package:meta/meta.dart';

class ItemRepository {
  final FoodloadApiClient foodloadApiClient;
  final SocketService socketService;

  final _items = Items();
  final itemsDummy = [
    Item(
      id: '1',
      title: 'Milk',
      description: 'Arla Milk',
      amount: 5,
    ),
    Item(
      id: '2',
      title: 'Bread',
      description: 'Pagen',
      amount: 2,
    ),
    Item(
      id: '3',
      title: 'Yoghurt',
      description: 'Strawberry yoghurt',
      amount: 3,
    ),
  ];

  ItemRepository(
      {@required this.foodloadApiClient, @required this.socketService})
      : assert(foodloadApiClient != null && socketService != null);

  Stream<List<Item>> items() {
    getItems();
    return _items.stream;
  }

  Future<ItemInfo> getItem(String id) async {
    //TODO: API stuff

    final item =
        itemsDummy.firstWhere((item) => item.id == id, orElse: () => null);
    if (item == null) return null;
    return ItemInfo(
      id: item.id,
      title: item.title,
    );
  }

  Future<List<Item>> getItems() async {
    //TODO: API CALL TO GET ITEMS OR GET ITEMS THROUGH SOCKET
    await Future.delayed(
        const Duration(milliseconds: 2000)); //Simulate time for testing...
    final receivedItems = itemsDummy;
    return receivedItems;
//    _items.updateItems(receivedItems);
  }

  void setOnUpdateItem(Function onUpdateItem) {
    socketService.setOnUpdateItem(onUpdateItem);
  }
}
