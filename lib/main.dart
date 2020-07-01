import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/app_theme.dart';
import 'package:foodload_flutter/blocs/auth/auth_bloc.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/simple_bloc_delegate.dart';
import 'package:foodload_flutter/ui/screens/landing_screen.dart';
import 'package:foodload_flutter/ui/screens/loading_screen.dart';
import 'package:foodload_flutter/ui/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(BlocProvider(
    create: (context) =>
        AuthBloc(userRepository: userRepository)..add(AuthStarted()),
    child: App(userRepository: userRepository),
  ));
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

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
            return LoginScreen(
              userRepository: _userRepository,
            );
          } else {
            return LandingScreen();
          }
        },
      ),
    );
  }
}
