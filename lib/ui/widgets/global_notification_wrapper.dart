import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/global_notification/global_notification.dart';
import 'package:foodload_flutter/helpers/error_handler/core/error_handler.dart';
import 'package:foodload_flutter/helpers/global_keys.dart';

class GlobalNotificationWrapper extends StatefulWidget {
  final Widget child;

  const GlobalNotificationWrapper({this.child});

  @override
  _GlobalNotificationWrapperState createState() =>
      _GlobalNotificationWrapperState();
}

class _GlobalNotificationWrapperState extends State<GlobalNotificationWrapper> {
  final GlobalNotificationBloc _bloc = GlobalNotificationBloc()
    ..add(GlobalNotificationStart());

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalNotificationBloc, GlobalNotificationState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is GlobalNotificationUpdated) {
          print(state.message);
          Navigator.of(GlobalKeys.globalKey.currentContext)
              .pushNamed('notify', arguments: state.message);
        }
      },
      child: widget.child,
    );
  }
}
