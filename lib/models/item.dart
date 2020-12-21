import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Item extends Equatable {
  final int id;
  final String qrCode;
  final String title;
  final String description;
  final int amount;
  final String storageType;

  const Item({
    @required this.id,
    @required this.qrCode,
    @required this.title,
    @required this.description,
    @required this.amount,
    @required this.storageType,
  });

  @override
  List<Object> get props => [
        id,
        qrCode,
        title,
        description,
        amount,
        storageType,
      ];

  @override
  String toString() =>
      'Item { id: $id, qrCode: $qrCode, title: $title, description: $description, amount: $amount, storageType: $storageType}';

  Item copyWith({int amount}) {
    return Item(
      id: this.id,
      qrCode: this.qrCode,
      title: this.title,
      description: this.description,
      amount: amount ?? this.amount,
      storageType: this.storageType,
    );
  }

  Item.fromJson(Map<String, dynamic> json)
      : id = json['itemCountId'],
        qrCode = json['qrCode'],
        title = json['name'],
        description = json['brand'],
        amount = json['amount'],
        storageType = json['storageType'];

  Item.fromItemCountJson(Map<String, dynamic> json)
      : id = json['id'],
        storageType = json['storageType'],
        amount = json['amount'],
        title = json['item']['name'],
        description = json['item']['brand'],
        qrCode = json['item']['qrCode'];
}
