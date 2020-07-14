import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String id;
  final String title;
  final String description;
  final int amount;
  final String imageUrl;

  const Item({
    this.id,
    this.title,
    this.description,
    this.amount,
    this.imageUrl,
  });

  @override
  List<Object> get props => [
        id,
        title,
        description,
        amount,
      ];

  @override
  String toString() =>
      'Item { id: $id, title: $title, description: $description, amount: $amount}';
}
