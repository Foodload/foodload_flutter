import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Item extends Equatable {
  final String id;
  final String title;
  final String description;
  final int amount;

  const Item({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.amount,
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
