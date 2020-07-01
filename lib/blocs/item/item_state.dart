import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemInitial extends ItemState {}

class ItemSendInProgress extends ItemState {}

class ItemSendSuccess extends ItemState {}

class ItemSendFailure extends ItemState {}
