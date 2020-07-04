import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/app_theme.dart';
import 'package:foodload_flutter/blocs/auth/auth_bloc.dart';
import 'package:foodload_flutter/blocs/item/bloc.dart';
import 'package:foodload_flutter/data/providers/foodload_api_client.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/simple_bloc_delegate.dart';
import 'package:foodload_flutter/ui/screens/landing_screen.dart';
import 'package:foodload_flutter/ui/screens/loading_screen.dart';
import 'package:foodload_flutter/ui/screens/login_screen.dart';
import 'package:foodload_flutter/ui/screens/storage_overview_screen.dart';
import 'package:http/http.dart' as http;
import 'package:foodload_flutter/blocs/login/login_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
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
        BlocProvider<ItemBloc>(
          create: (context) {
            return ItemBloc(
                itemRepository: ItemRepository(
                  foodloadApiClient:
                      FoodloadApiClient(httpClient: http.Client()),
                ),
                userRepository: _userRepository);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Foodload',
        theme: AppTheme.darkTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial) {
              return LoadingScreen();
            } else if (state is AuthFailure) {
              return BlocProvider(
                create: (context) => LoginBloc(userRepository: _userRepository),
                child: LoginScreen(),
              );
            } else {
              return LandingScreen();
            }
          },
        ),
        routes: {
          StorageOverviewScreen.routeName: (ctx) => StorageOverviewScreen(),
        },
      ),
    );
  }
}
