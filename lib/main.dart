import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/auth/auth_bloc.dart';
import 'package:foodload_flutter/blocs/items/items.dart';
import 'package:foodload_flutter/blocs/simple_bloc_observer.dart';
import 'package:foodload_flutter/data/providers/foodload_api_client.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/foodload_app.dart';
import 'package:http/http.dart' as http;

import 'data/providers/socket_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var _socketService;
  var _foodloadApiClient;
  var _userRepository;
  var _itemRepository;

  @override
  void initState() {
    super.initState();
    _socketService = SocketService();
    _foodloadApiClient = FoodloadApiClient(httpClient: http.Client());
    _userRepository = UserRepository(foodloadApiClient: _foodloadApiClient);
    _itemRepository = ItemRepository(
      foodloadApiClient: _foodloadApiClient,
      socketService: _socketService,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) {
            return AuthBloc(userRepository: _userRepository)
              ..add(AuthStarted());
          },
        ),
        BlocProvider<ItemsBloc>(
          create: (context) {
            return ItemsBloc(
              itemRepository: _itemRepository,
              userRepository: _userRepository,
            )..add(
                ItemsLoad(),
              );
          },
        ),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<UserRepository>.value(value: _userRepository),
          RepositoryProvider<ItemRepository>.value(value: _itemRepository),
        ],
        child: FoodLoadApp(),
      ),
    );
  }
}
