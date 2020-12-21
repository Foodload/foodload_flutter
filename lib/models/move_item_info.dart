import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MoveItemInfo extends Equatable {
  final int amount;

  const MoveItemInfo({
    @required this.amount,
  });

  @override
  List<Object> get props => [amount];

  @override
  String toString() {
    return 'MoveItemInfo { amount: $amount }';
  }

  MoveItemInfo.fromJson(Map<String, dynamic> json) : amount = json['amount'];
}
