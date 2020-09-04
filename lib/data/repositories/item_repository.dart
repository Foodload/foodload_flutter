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
  final List<ItemInfo> searchDummy = [
    ItemInfo(qrCode: '1', title: 'Mjölk1', brand: 'Arla'),
    ItemInfo(qrCode: '2', title: 'Mjölk2', brand: 'Arla'),
    ItemInfo(qrCode: '3', title: 'Mjölk3', brand: 'Arla'),
    ItemInfo(qrCode: '4', title: 'Mjölk4', brand: 'Arla'),
    ItemInfo(qrCode: '5', title: 'Mjölk5', brand: 'Arla'),
    ItemInfo(qrCode: '6', title: 'Mjölk6', brand: 'Arla'),
    ItemInfo(qrCode: '7', title: 'Mjölk7', brand: 'Arla'),
    ItemInfo(qrCode: '8', title: 'Mjölk8', brand: 'Arla'),
    ItemInfo(qrCode: '9', title: 'Mjölk9', brand: 'Arla'),
    ItemInfo(qrCode: '10', title: 'Mjölk10', brand: 'Arla'),
    ItemInfo(qrCode: '11', title: 'Mjölk11', brand: 'Arla'),
    ItemInfo(qrCode: '12', title: 'Mjölk12', brand: 'Arla'),
    ItemInfo(qrCode: '13', title: 'Mjölk13', brand: 'Arla'),
    ItemInfo(qrCode: '14', title: 'Mjölk14', brand: 'Arla'),
    ItemInfo(qrCode: '15', title: 'Mjölk15', brand: 'Arla'),
    ItemInfo(qrCode: '16', title: 'Mjölk16', brand: 'Arla'),
    ItemInfo(qrCode: '17', title: 'Mjölk17', brand: 'Arla'),
    ItemInfo(qrCode: '18', title: 'Mjölk18', brand: 'Arla'),
    ItemInfo(qrCode: '19', title: 'Mjölk19', brand: 'Arla'),
    ItemInfo(qrCode: '20', title: 'Mjölk20', brand: 'Arla'),
    ItemInfo(qrCode: '21', title: 'Mjölk21', brand: 'Arla'),
    ItemInfo(qrCode: '22', title: 'Mjölk22', brand: 'Arla'),
    ItemInfo(qrCode: '23', title: 'Mjölk23', brand: 'Arla'),
    ItemInfo(qrCode: '24', title: 'Mjölk24', brand: 'Arla'),
    ItemInfo(qrCode: '25', title: 'Mjölk25', brand: 'Arla'),
    ItemInfo(qrCode: '26', title: 'Mjölk26', brand: 'Arla'),
    ItemInfo(qrCode: '27', title: 'Mjölk27', brand: 'Arla'),
    ItemInfo(qrCode: '28', title: 'Mjölk28', brand: 'Arla'),
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
      qrCode: item.qrCode,
      title: item.title,
      brand: item.description,
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
    // final res = searchDummy
    //     .where((element) => element.title.contains(searchText))
    //     .toList();
    // if (start + offset <= res.length) {
    //   return res.sublist(start, start + offset).toList();
    // } else {
    //   return [];
    // }
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
