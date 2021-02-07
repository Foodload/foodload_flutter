import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:meta/meta.dart';

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

  @override
  List<Object> get props => [id, count, itemInfo];

  @override
  String toString() =>
      'TemplateItem {id: $id, count: $count, itemInfo: $itemInfo}';
}
