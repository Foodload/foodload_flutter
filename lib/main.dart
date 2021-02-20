import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/auth/auth_bloc.dart';
import 'package:foodload_flutter/blocs/items/items.dart';
import 'package:foodload_flutter/blocs/simple_bloc_observer.dart';
import 'package:foodload_flutter/blocs/socket/bloc.dart';
import 'package:foodload_flutter/data/providers/foodload_api_client.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/template_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/foodload_app.dart';
import 'package:foodload_flutter/helpers/error_handler/core/error_handler.dart';
import 'package:foodload_flutter/helpers/error_handler/mode/dialog_report_mode.dart';
import 'package:foodload_flutter/helpers/error_handler/mode/silent_report_mode.dart';
import 'package:foodload_flutter/helpers/global_keys.dart';

import 'data/providers/socket_client.dart';
import 'helpers/error_handler/handlers/console_handler.dart';
import 'helpers/error_handler/mode/dialog_report_mode_exit.dart';
import 'helpers/error_handler/model/error_handler_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  //TODO: Uncomment
  /*
  var explicitReportModesMap = {
    "SilentLogException": SilentReportMode(),
    "ComponentLogException": DialogReportMode(),
  };
  ErrorHandlerOptions debugOptions = ErrorHandlerOptions(
    DialogReportModeExit(),
    [
      ConsoleHandler(),
    ],
    explicitExceptionReportModesMap: explicitReportModesMap,
  );
  ErrorHandlerOptions releaseOptions = ErrorHandlerOptions(
    DialogReportModeExit(),
    [
      //TODO: Add HttpHandler
    ],
    explicitExceptionReportModesMap: explicitReportModesMap,
  );
   */

  ErrorHandler(
    rootWidget: App(),
    navigatorKey: GlobalKeys.globalKey,
    //debugConfig: debugOptions,
    //releaseConfig: releaseOptions,
  );
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
  var _templateRepository;
  AuthBloc _authBloc;
  SocketBloc _socketBloc;

  @override
  void initState() {
    super.initState();
    _socketService = SocketClient();
    _foodloadApiClient = FoodloadApiClient();
    _userRepository = UserRepository(foodloadApiClient: _foodloadApiClient);
    _itemRepository = ItemRepository(
      foodloadApiClient: _foodloadApiClient,
      socketService: _socketService,
    );
    _templateRepository =
        TemplateRepository(foodloadApiClient: _foodloadApiClient);
    _authBloc = AuthBloc(userRepository: _userRepository)..add(AuthStarted());
    _socketBloc = SocketBloc(
        userRepository: _userRepository,
        authBloc: _authBloc,
        socketService: _socketService);
  }

  @override
  void dispose() {
    super.dispose();
    _authBloc.close();
    _socketBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(
          value: _authBloc,
//          create: (context) {
//            return AuthBloc(userRepository: _userRepository)
//              ..add(AuthStarted());
//          },
        ),
        BlocProvider<SocketBloc>.value(
          value: _socketBloc,
        ),
        BlocProvider<ItemsBloc>(
          create: (context) {
            return ItemsBloc(
              itemRepository: _itemRepository,
              userRepository: _userRepository,
              authBloc: _authBloc,
            );
          },
          //lazy: false,
        ),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<UserRepository>.value(value: _userRepository),
          RepositoryProvider<ItemRepository>.value(value: _itemRepository),
          RepositoryProvider<TemplateRepository>.value(
              value: _templateRepository),
        ],
        child: FoodLoadApp(GlobalKeys.globalKey),
      ),
    );
  }
}
