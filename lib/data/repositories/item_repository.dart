import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodload_flutter/data/providers/foodload_api_client.dart';
import 'package:foodload_flutter/data/providers/socket_client.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:foodload_flutter/models/items.dart';
import 'package:foodload_flutter/models/item_updated_info.dart';
import 'package:meta/meta.dart';

class ItemRepository {
  final FoodloadApiClient _foodloadApiClient;
  final SocketClient _socketService;

  Items _items;

  ItemRepository({@required foodloadApiClient, @required socketService})
      : assert(foodloadApiClient != null && socketService != null),
        _foodloadApiClient = foodloadApiClient,
        _socketService = socketService;

  Future<List<Item>> init(String token) async {
    final respJson = await _foodloadApiClient.getItemCounts(token);
    List<Item> items =
        (respJson as List).map((jsonItem) => Item.fromJson(jsonItem)).toList();
    _items = Items(items);
    _configItemWithSocket();
    return [...items];
  }

  void _configItemWithSocket() {
    final socket = _socketService.socket;
    socket.on(SocketClient.UPDATE_ITEM, (data) {
      Map<String, dynamic> decoded = jsonDecode(data);
      final item = Item.fromJson(decoded);
      _items.updateWithItem(item);
    });
    socket.on(SocketClient.MOVE_ITEM, (data) {
      Map<String, dynamic> decoded = jsonDecode(data);
      final srcItem = Item.fromItemCountJson(decoded['srcItemCount']);
      final destItem = Item.fromItemCountJson(decoded['destItemCount']);
      _items.updateWithItems([srcItem, destItem]);
    });
    socket.on(SocketClient.DELETE_ITEM, (data) {
      Map<String, dynamic> decoded = jsonDecode(data);
      _items.deleteItem(decoded['itemCountId']);
    });
  }

  Stream<List<Item>> itemsStream() {
    return _items.itemsStream;
  }

  Items items() {
    return _items;
  }

  Future<ItemInfo> getItem(String qr, String token) async {
    final respJson = await _foodloadApiClient.findItemByQr(qr, token);
    final itemInfo = ItemInfo.fromJson(respJson);
    return itemInfo;
  }

  Future<List<Item>> getItemCounts(String token) async {
    List<Item> items = await _foodloadApiClient.getItemCounts(token);
    return items;
  }

  Future<void> incrementItem(String token, int id) async {
    await _foodloadApiClient.incrementItem(token, id);
  }

  Future<void> decrementItem(String token, int id) async {
    await _foodloadApiClient.decrementItem(token, id);
  }

  Future<List<ItemInfo>> searchForItem(
      String searchText, int startIndex, String userToken) async {
    final respJson = await _foodloadApiClient.findItemByName(
        searchText, startIndex, userToken);
    List<ItemInfo> results = (respJson as List)
        .map((jsonItem) => ItemInfo.fromJson(jsonItem))
        .toList();
    return results;
  }

  Future<void> addItem(
      {String qr, int amount, String token, String storageType}) async {
    await _foodloadApiClient.addItemQR(
        qr: qr, amount: amount, storageType: storageType, token: token);
  }

  Future<void> removeItem(String token, String qr, String storageType) async {
    await _foodloadApiClient.removeItemQR(token, qr, storageType);
  }

  Future<ItemUpdatedInfo> moveItemToStorage(
      {String token,
      String storageType,
      int moveAmount,
      int id,
      int oldAmount}) async {
    final respJson = await _foodloadApiClient.moveItemToStorage(
        token: token,
        storageType: storageType,
        moveAmount: moveAmount,
        oldAmount: oldAmount,
        id: id);
    return ItemUpdatedInfo.fromJson(respJson);
  }

  Future<ItemUpdatedInfo> moveItemFromStorage(
      {String token,
      String storageType,
      int moveAmount,
      int id,
      int oldAmount}) async {
    final respJson = await _foodloadApiClient.moveItemFromStorage(
        token: token,
        storageType: storageType,
        moveAmount: moveAmount,
        oldAmount: oldAmount,
        id: id);
    return ItemUpdatedInfo.fromJson(respJson);
  }

  Future<void> deleteItem({
    String token,
    int amount,
    int id,
  }) async {
    await _foodloadApiClient.deleteItem(token: token, amount: amount, id: id);
  }

  Future<ItemUpdatedInfo> updateItemAmount(
      {String token, int id, int newAmount, int oldAmount}) async {
    final respJson = await _foodloadApiClient.updateItemAmount(
      id: id,
      token: token,
      newAmount: newAmount,
      oldAmount: oldAmount,
    );
    return ItemUpdatedInfo.fromJson(respJson);
  }
}
