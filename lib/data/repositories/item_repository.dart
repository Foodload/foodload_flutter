import 'package:flutter/material.dart';
import 'package:foodload_flutter/data/providers/foodload_api_client.dart';
import 'package:foodload_flutter/data/providers/socket_service.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:foodload_flutter/models/items.dart';
import 'package:foodload_flutter/models/item_updated_info.dart';
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

  Future<List<Item>> getItemCounts(String token) async {
    List<Item> items = await foodloadApiClient.getItemCounts(token);
    return items;
  }

  void setOnUpdateItem(Function onUpdateItem) {
    socketService.setOnUpdateItem(onUpdateItem);
  }

  void setOnMoveItem(Function onMoveItem) {
    socketService.setOnMoveItem(onMoveItem);
  }

  void setOnDeleteItem(Function onDeleteItem) {
    socketService.setOnDeleteItem(onDeleteItem);
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

  Future<void> addItem(
      {String qr, int amount, String token, String storageType}) async {
    await foodloadApiClient.addItemQR(
        qr: qr, amount: amount, storageType: storageType, token: token);
  }

  Future<void> removeItem(String token, String qr, String storageType) async {
    //TODO: API stuff
    await foodloadApiClient.removeItemQR(token, qr, storageType);
  }

  Future<ItemUpdatedInfo> moveItemToStorage(
      {String token,
      String storageType,
      int moveAmount,
      int id,
      int oldAmount}) async {
    final itemUpdatedInfo = await foodloadApiClient.moveItemToStorage(
        token: token,
        storageType: storageType,
        moveAmount: moveAmount,
        oldAmount: oldAmount,
        id: id);
    //TODO: Response... ok = new amount is returned, not ok 20.. could not update = new amount, etc.. More info needed!
    return itemUpdatedInfo;
  }

  Future<ItemUpdatedInfo> moveItemFromStorage(
      {String token,
      String storageType,
      int moveAmount,
      int id,
      int oldAmount}) async {
    final itemUpdatedInfo = await foodloadApiClient.moveItemFromStorage(
        token: token,
        storageType: storageType,
        moveAmount: moveAmount,
        oldAmount: oldAmount,
        id: id);
    //TODO: Response... ok = new amount is returned, not ok 20.. could not update = new amount, etc.. More info needed!
    return itemUpdatedInfo;
  }

  Future<void> deleteItem({
    String token,
    int amount,
    int id,
  }) async {
    await foodloadApiClient.deleteItem(token: token, amount: amount, id: id);
  }

  Future<ItemUpdatedInfo> updateItemAmount(
      {String token, int id, int newAmount, int oldAmount}) async {
    final itemUpdateInfo = await foodloadApiClient.updateItemAmount(
        id: id, token: token, newAmount: newAmount, oldAmount: oldAmount);
    return itemUpdateInfo;
  }

  //TODO: Necessary?
  /**
  Future<void> checkFridge(String token) async {

    await foodloadApiClient.checkFridge(token);
  }
      */
}
