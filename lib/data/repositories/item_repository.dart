import 'package:foodload_flutter/data/providers/foodload_api_client.dart';
import 'package:foodload_flutter/models/item.dart';
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
        imageUrl:
            'https://static.mathem.se/shared/images/products/medium/07310865001825_g1l1.jpeg.jpg',
      ),
      Item(
        id: '2',
        title: 'Bread',
        description: 'Pagen',
        amount: 2,
        imageUrl:
            'https://assets.icanet.se/t_product_large_v1,f_auto/7311070008470.jpg',
      ),
      Item(
        id: '3',
        title: 'Yoghurt',
        description: 'Strawberry yoghurt',
        amount: 3,
      ),
    ];
  }
}
