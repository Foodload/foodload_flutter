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
      id: 1,
      qrCode: '1',
      title: 'Milk',
      description: 'Arla Milk',
      amount: 5,
    ),
    Item(
      id: 2,
      qrCode: '2',
      title: 'Bread',
      description: 'Pagen',
      amount: 2,
    ),
    Item(
      id: 3,
      qrCode: '3',
      title: 'Yoghurt',
      description: 'Strawberry yoghurt',
      amount: 3,
    ),
  ];

  ItemRepository(
      {@required this.foodloadApiClient, @required this.socketService})
      : assert(foodloadApiClient != null && socketService != null);

  Stream<List<Item>> items() {
    //getItems();
    return _items.stream;
  }

  Future<ItemInfo> getItem(String qr) async {
    //TODO: API stuff

    final item =
        itemsDummy.firstWhere((item) => item.qrCode == qr, orElse: () => null);
    if (item == null) return null;
    return ItemInfo(
      id: item.id,
      title: item.title,
    );
  }

  Future<List<Item>> getItems(String token) async {
    //TODO: API CALL TO GET >>>ALL<<< ITEMS OR GET ITEMS THROUGH SOCKET
    List<Item> items = await foodloadApiClient.checkFridge(token);
    return items;
  }

  void setOnUpdateItem(Function onUpdateItem) {
    socketService.setOnUpdateItem(onUpdateItem);
  }

  Future<void> incrementItem(String token, int id) async {
    await foodloadApiClient.incrementItem(token, id);
  }

  Future<void> decrementItem(String token, int id) async {
    await foodloadApiClient.decrementItem(token, id);
  }

  Future<void> addItem(String token, String qr, String storageType) async {
    //TODO: API stuff
    await foodloadApiClient.addItemQR(token, qr, storageType);
  }

  Future<void> removeItem(String token, String qr, String storageType) async {
    //TODO: API stuff
    await foodloadApiClient.removeItemQR(token, qr, storageType);
  }

  Future<void> checkFridge(String token) async {
    await foodloadApiClient.checkFridge(token);
  }
}
