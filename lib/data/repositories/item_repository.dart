import 'package:foodload_flutter/data/providers/foodload_api_client.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/models/item_representation.dart';
import 'package:meta/meta.dart';

class ItemRepository {
  final FoodloadApiClient foodloadApiClient;

  ItemRepository({@required this.foodloadApiClient})
      : assert(foodloadApiClient != null);

  Future<void> sendToken(String token) async {
    print('From Item Repo: $token');
    await foodloadApiClient.sendToken(token);
  }

  Future<List<ItemRepresentation>> getItems() async {
    //api stuff
    final item1 = Item(id: '1', expiryDate: DateTime.now());
    final item2 = Item(id: '2', expiryDate: DateTime.now());
    final item3 = Item(id: '3', expiryDate: DateTime.now());
    final item4 = Item(id: '4', expiryDate: DateTime.now());
    final item5 = Item(id: '5', expiryDate: DateTime.now());
    final item6 = Item(id: '6', expiryDate: DateTime.now());
    final item7 = Item(id: '7', expiryDate: DateTime.now());
    final item8 = Item(id: '8', expiryDate: DateTime.now());
    return [
      ItemRepresentation(
          id: '1',
          title: 'Milk',
          description: 'Arla Milk',
          items: [item1, item2, item3, item4, item5, item6, item7, item8]),
    ];
  }
}
