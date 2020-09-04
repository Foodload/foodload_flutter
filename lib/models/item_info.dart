import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ItemInfo extends Equatable {
  final String qrCode;
  final String title;
  final String brand;

  const ItemInfo({
    @required this.qrCode,
    @required this.title,
    @required this.brand,
  });

  @override
  List<Object> get props => [qrCode, title];

  @override
  String toString() {
    return 'ItemInfo { qrCode: $qrCode, title: $title, brand: $brand }';
  }

  ItemInfo.fromJson(Map<String, dynamic> json)
      : qrCode = json['qrCode'],
        title = json['name'],
        brand = json['brand'];
}
