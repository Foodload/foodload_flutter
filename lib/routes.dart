import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/ui/screens/add_item_screen.dart';
import 'package:foodload_flutter/ui/screens/family_screen.dart';
import 'package:foodload_flutter/ui/screens/item_settings_screen.dart';
import 'package:foodload_flutter/ui/screens/landing_screen.dart';
import 'package:foodload_flutter/ui/screens/loading_screen.dart';
import 'package:foodload_flutter/ui/screens/login_screen.dart';
import 'package:foodload_flutter/ui/screens/search_item_screen.dart';
import 'package:foodload_flutter/ui/screens/storage_overview_screen.dart';
import 'package:foodload_flutter/ui/screens/templates_overview_screen.dart';
import 'package:foodload_flutter/ui/screens/test_screen.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/login/login_bloc.dart';
import 'blocs/search_item/search_item_bloc.dart';
import 'data/repositories/item_repository.dart';
import 'data/repositories/user_repository.dart';

Route routes(RouteSettings settings) {
  switch (settings.name) {
    case StorageOverviewScreen.routeName:
      return buildRoute(settings, StorageOverviewScreen());
    case AddItemScreen.routeName:
      return buildRoute(settings, AddItemScreen());
    case ItemSettingsScreen.routeName:
      return buildRoute(settings, ItemSettingsScreen());
    case TestScreen.routeName:
      return buildRoute(settings, TestScreen());
    case SearchItemScreen.routeName:
      return buildRoute(
          settings,
          BlocProvider<SearchItemBloc>(
            create: (context) => SearchItemBloc(
              userRepository: RepositoryProvider.of<UserRepository>(context),
              itemRepository: RepositoryProvider.of<ItemRepository>(context),
            ),
            child: SearchItemScreen(),
          ));
    case TemplatesOverviewScreen.routeName:
      return buildRoute(settings, TemplatesOverviewScreen());
    case FamilyScreen.routeName:
      return buildRoute(settings, FamilyScreen());
    //Global Notification TODO: Implement argument & create styled bars for success, error, neutral etc
    case 'notify':
      return buildNotification(Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        titleText:
            Text(settings.arguments, style: TextStyle(color: Colors.white)),
        messageText:
            Text(settings.arguments, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ));
    default:
      return buildRoute(
        settings,
        BlocBuilder<AuthBloc, AuthState>(
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
      );
  }
}

//TODO: Move this
MaterialPageRoute buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(
    builder: (BuildContext context) => builder,
    settings: settings,
  );
}

//TODO: Move this and improve
FlushbarRoute buildNotification(Flushbar flushbar) {
  return FlushbarRoute(
    flushbar: flushbar,
    settings: RouteSettings(name: "Hej"),
  );
}
