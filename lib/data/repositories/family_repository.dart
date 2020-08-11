import 'package:flutter/material.dart';
import 'package:foodload_flutter/data/providers/foodload_api_client.dart';
import 'package:meta/meta.dart';

class FamilyRepository {
  final FoodloadApiClient foodloadApiClient;

  FamilyRepository({@required this.foodloadApiClient})
      : assert(foodloadApiClient != null);

  Future<String> getFamilyToken(String userToken) {
    //TODO: get family token
  }
}
