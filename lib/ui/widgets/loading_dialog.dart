import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingDialog extends StatefulWidget {
  final LoadingDialogBloc _bloc;

  const LoadingDialog(LoadingDialogBloc bloc) : _bloc = bloc;

  @override
  _LoadingDialogState createState() => _LoadingDialogState(_bloc);
}

class _LoadingDialogState extends State<LoadingDialog> {
  final LoadingDialogBloc _dialogBloc;

  _LoadingDialogState(this._dialogBloc);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoadingDialogBloc, DialogState>(
      child: Container(),
      listenWhen: (prevState, currentState) {
        if (prevState is DialogVisible) {
          Navigator.pop(context);
        }
        return prevState != currentState;
      },
      listener: (context, state) {
        if (state is DialogVisible) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: SimpleDialog(
                    backgroundColor: Colors.black54,
                    children: <Widget>[
                      Center(
                        child: Column(
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Please wait...',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        }
      },
    );
  }
}

abstract class DialogEvent {}

class ShowDialog extends DialogEvent {}

class HideDialog extends DialogEvent {}

abstract class DialogState {}

class InitialDialogState extends DialogState {}

class DialogHidden extends DialogState {}

class DialogVisible extends DialogState {}

class LoadingDialogBloc extends Bloc<DialogEvent, DialogState> {
  LoadingDialogBloc() : super(InitialDialogState());

  @override
  Stream<DialogState> mapEventToState(
    DialogEvent event,
  ) async* {
    if (event is ShowDialog) {
      yield DialogVisible();
    } else {
      yield DialogHidden();
      yield InitialDialogState();
    }
  }
}
