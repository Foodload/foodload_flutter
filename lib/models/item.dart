import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Item extends Equatable {
  final int id;
  final String qrCode;
  final String title;
  final String description;
  final int amount;

  const Item({
    @required this.id,
    @required this.qrCode,
    @required this.title,
    @required this.description,
    @required this.amount,
  });

  @override
  List<Object> get props => [
        id,
        qrCode,
        title,
        description,
        amount,
      ];

  @override
  String toString() =>
      'Item { id: $id, qrCode: $qrCode, title: $title, description: $description, amount: $amount}';

  Item copyWith({int amount}) {
    return Item(
      id: this.id,
      qrCode: this.qrCode,
      title: this.title,
      description: this.description,
      amount: amount ?? this.amount,
    );
  }

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        qrCode = json['qrCode'],
        title = json['name'],
        description = json['brand'],
        amount = json['amount'];
}
