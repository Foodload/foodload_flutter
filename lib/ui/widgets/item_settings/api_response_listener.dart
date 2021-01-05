import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/helpers/snackbar_helper.dart';
import 'package:foodload_flutter/models/enums/status.dart';

///Deprecated. Instead use BlocListener in a widget holder.
class ApiResponseListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemSettingsBloc, ItemSettingsState>(
      listener: (context, state) {
        if (state.apiStatus == Status.ERROR) {
          SnackBarHelper.showFailMessage(context, state.apiErrorText);
        }
      },
      child: Container(),
    );
  }
}
