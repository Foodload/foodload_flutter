import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/search_item/search_item.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:meta/meta.dart';

class SearchItemBloc extends Bloc<SearchItemEvent, SearchItemState> {
  final ItemRepository _itemRepository;
  final UserRepository _userRepository;

  SearchItemBloc({
    @required itemRepository,
    @required userRepository,
  })  : assert(itemRepository != null && userRepository != null),
        _itemRepository = itemRepository,
        _userRepository = userRepository,
        super(SearchItemInitial());

  @override
  Stream<SearchItemState> mapEventToState(SearchItemEvent event) async* {
    if (event is SearchItem) {
      yield* _mapSearchItemToState(event.searchText);
    } else if (event is LoadMoreSearchResults && !_hasReachedMax(state)) {
      yield* _mapLoadMoreSearchResultToState(state);
    }
  }

  Stream<SearchItemState> _mapSearchItemToState(String searchText) async* {
    yield SearchItemLoading();
    try {
      if (searchText.trim().isEmpty) {
        yield SearchItemInitial();
        return;
      }
      List<ItemInfo> results = await _itemRepository.searchForItem(searchText,
          0, await _userRepository.getToken()); //TODO: get 10 first?
      yield SearchItemSuccess(
          searchText: searchText,
          results: results,
          hasReachedMax: results.length < 10 ? true : false);
    } catch (error) {
      //TODO: More error handling perhaps
      print(error);
      yield SearchItemFailure();
    }
  }

  Stream<SearchItemState> _mapLoadMoreSearchResultToState(
      SearchItemState currentState) async* {
    try {
      if (currentState is SearchItemSuccess) {
        final searchText = currentState.searchText;
        final newStart = currentState.results.length;
        List<ItemInfo> moreResults = await _itemRepository.searchForItem(
            searchText,
            newStart,
            await _userRepository.getToken()); //TODO: try to get 10 more?
        yield moreResults.isEmpty || moreResults.length < 10
            ? currentState.copyWith(hasReachedMax: true)
            : currentState.copyWith(
                hasReachedMax: false,
                results: currentState.results + moreResults);
      }
      //TODO: Else throw error?
    } catch (error) {
      //TODO: More error handling
      yield SearchItemFailure();
    }
  }

  bool _hasReachedMax(SearchItemState state) =>
      state is SearchItemSuccess && state.hasReachedMax;
}
