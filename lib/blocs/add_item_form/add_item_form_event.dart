import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AddItemFormEvent extends Equatable {
  const AddItemFormEvent();

  @override
  List<Object> get props => [];
}

class ItemQrChanged extends AddItemFormEvent {
  final String qr;

  const ItemQrChanged({@required this.qr});

  @override
  List<Object> get props => [qr];

  @override
  String toString() => 'ItemQrChanged { qr: $qr }';
}

class ItemQrSearch extends AddItemFormEvent {
  final String qr;

  const ItemQrSearch({
    @required this.qr,
  });

  @override
  String toString() => 'ItemQrSearch { qr: $qr }';
}

class ItemAmountChanged extends AddItemFormEvent {
  final String amount;

  const ItemAmountChanged({@required this.amount});

  @override
  List<Object> get props => [amount];

  @override
  String toString() => 'ItemAmountChanged { amount: $amount }';
}

class ItemChange extends AddItemFormEvent {}

class ItemAdd extends AddItemFormEvent {
  final String amount;
  final storageType;

  const ItemAdd({this.amount, this.storageType});

  @override
  List<Object> get props => [amount, storageType];

  @override
  String toString() => 'ItemAdd { amount: $amount, storageType: $storageType }';
}

class AddItemFormReset extends AddItemFormEvent {}
