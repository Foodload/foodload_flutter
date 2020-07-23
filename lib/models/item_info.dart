import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ItemInfo extends Equatable {
  final String id;
  final String title;

  const ItemInfo({
    @required this.id,
    @required this.title,
  });

  @override
  List<Object> get props => [id, title];

  @override
  String toString() {
    return 'ItemInfo { id: $id, title: $title }';
  }
}
