import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:meta/meta.dart';

@immutable
class TemplateItem extends Equatable {
  final int id;
  final int count;
  final ItemInfo itemInfo;

  const TemplateItem(
      {@required this.id, @required this.count, @required this.itemInfo});

  TemplateItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        count = json['count'],
        itemInfo = ItemInfo.fromJson(json['item']);

  TemplateItem copyWith({int id, int count, ItemInfo itemInfo}) {
    return TemplateItem(
        id: id ?? this.id,
        count: count ?? this.count,
        itemInfo: itemInfo ?? this.itemInfo);
  }

  @override
  List<Object> get props => [id, count, itemInfo];

  @override
  String toString() =>
      'TemplateItem {id: $id, count: $count, itemInfo: $itemInfo}';
}
