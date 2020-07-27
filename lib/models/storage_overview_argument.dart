import 'package:foodload_flutter/models/storage_type.dart';
import 'package:meta/meta.dart';

class StorageOverviewArgument {
  final title;
  final StorageType storageType;

  const StorageOverviewArgument({
    @required this.title,
    @required this.storageType,
  });
}
