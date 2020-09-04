import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/search_item/search_item.dart';
import 'package:foodload_flutter/models/item_info.dart';

class SearchItemScreen extends StatefulWidget {
  static const routeName = '/search-item-screen';

  @override
  _SearchItemScreenState createState() => _SearchItemScreenState();
}

class _SearchItemScreenState extends State<SearchItemScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshHold = 100.0;
  SearchItemBloc _searchItemBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchItemBloc = BlocProvider.of<SearchItemBloc>(context);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshHold) {
      _searchItemBloc.add(LoadMoreSearchResults());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            icon: Icon(Icons.search),
            hintText: 'Search for item to add',
          ),
          onChanged: (searchText) {
            _searchItemBloc.add(SearchItem(searchText));
          },
        ),
      ),
      body: BlocBuilder<SearchItemBloc, SearchItemState>(
        builder: (context, state) {
          if (state is SearchItemInitial) {
            return Text('Hello');
          }
          if (state is SearchItemLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SearchItemFailure) {
            return Center(
              child: Text('Could not search for the item'),
            );
          }
          if (state is SearchItemSuccess) {
            if (state.results.isEmpty) {
              return Center(
                child: Text('No search results'),
              );
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.results.length
                    ? BottomLoader()
                    : FoundItem(state.results[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.results.length
                  : state.results.length + 1,
              controller: _scrollController,
            );
          }
          return Container();
        },
      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 33,
        height: 33,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
        ),
      ),
    );
  }
}

class FoundItem extends StatelessWidget {
  final ItemInfo itemInfo;

  const FoundItem(this.itemInfo);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(itemInfo.title),
      subtitle: Text(itemInfo.brand),
      dense: true,
    );
  }
}
