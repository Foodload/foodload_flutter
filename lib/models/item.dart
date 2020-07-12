import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String id;
  final DateTime expiryDate;

  const Item({this.id, this.expiryDate});

  @override
  List<Object> get props => [id, expiryDate];

  @override
  String toString() => 'Item { id: $id, expiryDate: $expiryDate }';
}
