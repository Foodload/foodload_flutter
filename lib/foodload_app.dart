import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/app_theme.dart';
import 'package:foodload_flutter/blocs/auth/auth_bloc.dart';
import 'package:foodload_flutter/blocs/filtered_items/filtered_items.dart';
import 'package:foodload_flutter/blocs/items/items.dart';
import 'package:foodload_flutter/blocs/login/bloc.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/ui/screens/add_item_screen.dart';
import 'package:foodload_flutter/ui/screens/landing_screen.dart';
import 'package:foodload_flutter/ui/screens/loading_screen.dart';
import 'package:foodload_flutter/ui/screens/login_screen.dart';
import 'package:foodload_flutter/ui/screens/storage_overview_screen.dart';

class FoodLoadApp extends StatelessWidget {
  const FoodLoadApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodload',
      theme: AppTheme.darkTheme,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            return LoadingScreen();
          } else if (state is AuthFailure) {
            return BlocProvider(
              create: (context) => LoginBloc(
                  userRepository:
                      RepositoryProvider.of<UserRepository>(context)),
              child: LoginScreen(),
            );
          } else {
            return LandingScreen();
          }
        },
      ),
      routes: {
        StorageOverviewScreen.routeName: (ctx) =>
            BlocProvider<FilteredItemsBloc>(
              create: (context) => FilteredItemsBloc(
                itemsBloc: BlocProvider.of<ItemsBloc>(context),
              ),
              child: StorageOverviewScreen(),
            ),
        AddItemScreen.routeName: (ctx) => AddItemScreen(),
      },
    );
  }
}
