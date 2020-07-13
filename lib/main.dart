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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userRepository = UserRepository();
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
                itemRepository: ItemRepository(
                  foodloadApiClient:
                      FoodloadApiClient(httpClient: http.Client()),
                ),
                userRepository: _userRepository)
              ..add(ItemsLoad());
          },
        ),
      ],
      child: FoodLoadApp(_userRepository),
    );
  }
}
