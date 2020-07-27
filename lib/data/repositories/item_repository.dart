import 'package:foodload_flutter/data/providers/foodload_api_client.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:meta/meta.dart';

class ItemRepository {
  final FoodloadApiClient foodloadApiClient;

  ItemRepository({@required this.foodloadApiClient})
      : assert(foodloadApiClient != null);

  Future<void> sendToken(String token) async {
    print('From Item Repo: $token');
    await foodloadApiClient.sendToken(token);
  }

  Future<List<Item>> getItems() async {
    //api stuff
    return [
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
  }

  Future<ItemInfo> getItem(String id) async {
    //api stuff
    List<ItemInfo> itemsDummy = [
      ItemInfo(
        id: '1',
        title: 'Milk',
      ),
      ItemInfo(
        id: '2',
        title: 'Bread',
      ),
      ItemInfo(
        id: '3',
        title: 'Yoghurt',
      ),
    ];

    return itemsDummy.firstWhere((itemInfo) => itemInfo.id == id,
        orElse: () => null);
  }
}
