import 'package:equatable/equatable.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemInit extends ItemState {}

class ItemSuccess extends ItemState {}

class ItemFailure extends ItemState {}

class ItemLoading extends ItemState {}
