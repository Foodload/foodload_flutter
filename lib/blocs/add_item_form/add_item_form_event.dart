import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AddItemFormEvent extends Equatable {
  const AddItemFormEvent();

  @override
  List<Object> get props => [];
}

class ItemIdChanged extends AddItemFormEvent {
  final String id;

  const ItemIdChanged({@required this.id});

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'ItemIdChanged { id: $id }';
}

class ItemIdSearch extends AddItemFormEvent {
  final String id;

  const ItemIdSearch({
    @required this.id,
  });

  @override
  String toString() => 'ItemIdFetched { id: $id }';
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

  const ItemAdd({this.amount});

  @override
  List<Object> get props => [amount];

  @override
  String toString() => 'ItemAdd { amount: $amount }';
}

class AddItemFormReset extends AddItemFormEvent {}
