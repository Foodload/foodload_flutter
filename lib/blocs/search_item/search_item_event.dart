import 'package:equatable/equatable.dart';

abstract class SearchItemEvent extends Equatable {
  const SearchItemEvent();

  @override
  List<Object> get props => [];
}

class LoadMoreSearchResults extends SearchItemEvent {}

class SearchItem extends SearchItemEvent {
  final String searchText;

  const SearchItem(this.searchText);

  @override
  List<Object> get props => [searchText];

  @override
  String toString() {
    return 'SearchItem { searchText: $searchText }';
  }
}
