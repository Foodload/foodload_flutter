import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/models/storage_type.dart';
import 'package:meta/meta.dart';

class ItemDetailArgument {
  final Item item;
  //final StorageType storageType;

  const ItemDetailArgument({
    @required this.item,
    //@required this.storageType,
  });
}
