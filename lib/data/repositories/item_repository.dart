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

  ItemRepository(
      {@required this.foodloadApiClient, @required this.socketService})
      : assert(foodloadApiClient != null && socketService != null);

  Stream<List<Item>> items() {
    return _items.stream;
  }

  Future<ItemInfo> getItem(String qr, String token) async {
    final item = await this.foodloadApiClient.findItemByQr(qr, token);
    return ItemInfo(
      qrCode: item.qrCode,
      title: item.title,
      brand: item.brand,
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

  Future<List<ItemInfo>> searchForItem(
      String searchText, int startIndex, String userToken) async {
    final res = await foodloadApiClient.findItemByName(
        searchText, startIndex, userToken);
    return res;
  }

  Future<void> addItem(String qr, int amount, String token) async {
    await foodloadApiClient.addItemQR(qr, amount, token);
  }

  Future<void> removeItem(String token, String qr, String storageType) async {
    //TODO: API stuff
    await foodloadApiClient.removeItemQR(token, qr, storageType);
  }

  Future<void> checkFridge(String token) async {
    await foodloadApiClient.checkFridge(token);
  }
}
