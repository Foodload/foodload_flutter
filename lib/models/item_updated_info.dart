import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ItemUpdatedInfo extends Equatable {
  final int amount;

  const ItemUpdatedInfo({
    @required this.amount,
  });

  @override
  List<Object> get props => [amount];

  @override
  String toString() {
    return 'ItemUpdatedInfo { amount: $amount }';
  }

  ItemUpdatedInfo.fromJson(Map<String, dynamic> json) : amount = json['amount'];
}
