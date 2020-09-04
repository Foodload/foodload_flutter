import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/item_info.dart';

abstract class SearchItemState extends Equatable {
  const SearchItemState();

  @override
  List<Object> get props => [];
}

class SearchItemInitial extends SearchItemState {}

class SearchItemFailure extends SearchItemState {}

class SearchItemLoading extends SearchItemState {}

class SearchItemSuccess extends SearchItemState {
  final String searchText;
  final List<ItemInfo> results;
  final bool hasReachedMax;

  const SearchItemSuccess({this.searchText, this.results, this.hasReachedMax});

  SearchItemSuccess copyWith(
      {String searchText, List<ItemInfo> results, bool hasReachedMax}) {
    return SearchItemSuccess(
      searchText: searchText ?? this.searchText,
      results: results ?? this.results,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [searchText, results, hasReachedMax];

  @override
  String toString() =>
      'SearchItemSuccess { searchText: $searchText, results: ${results.length}, hasReachedMax: $hasReachedMax }';
}
