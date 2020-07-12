import 'package:equatable/equatable.dart';

class ItemRepresentation extends Equatable {
  final String id;
  final String title;
  final String description;
  final int amount;
  final String imageUrl;

  const ItemRepresentation({
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
      'ItemRepresentation { id: $id, title: $title, description: $description, amount: $amount}';
}
