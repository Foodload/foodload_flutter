import 'package:foodload_flutter/data/providers/foodload_api_client.dart';
import 'package:meta/meta.dart';

class ItemRepository {
  final FoodloadApiClient foodloadApiClient;

  ItemRepository({@required this.foodloadApiClient})
      : assert(foodloadApiClient != null);

  Future<void> sendToken(String token) async {
    print('From Item Repo: $token');
    await foodloadApiClient.sendToken(token);
  }
}
