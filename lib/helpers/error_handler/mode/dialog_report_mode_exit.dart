import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodload_flutter/helpers/error_handler/model/localization_options.dart';
import 'package:foodload_flutter/helpers/error_handler/model/platform_type.dart';
import 'package:foodload_flutter/helpers/error_handler/model/report.dart';
import 'package:foodload_flutter/helpers/error_handler/model/report_mode.dart';
import 'package:foodload_flutter/helpers/error_handler/utils/error_handler_utils.dart';
import 'package:foodload_flutter/helpers/error_handler/model/error_status.dart';
import 'package:foodload_flutter/helpers/error_handler/model/status.dart';

class DialogReportModeExit extends ReportMode {
  @override
  void requestAction(Report report, BuildContext context) {
    _showDialog(report, context);
  }

  Future _showDialog(Report report, BuildContext context) async {
    await Future<void>.delayed(Duration.zero);
    if (ErrorHandlerUtils.isCupertinoAppAncestor(context)) {
      return showCupertinoDialog<void>(
          context: context,
          builder: (context) => _buildCupertinoDialog(report, context));
    } else {
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => _buildMaterialDialog(report, context));
    }
  }

  Widget _buildCupertinoDialog(Report report, BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(localizationOptions.dialogReportModeTitle),
      content: Text(localizationOptions.dialogReportModeDescription),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(localizationOptions.dialogReportModeAccept),
          onPressed: () => _onAcceptReportClicked(context, report),
        ),
        CupertinoDialogAction(
          child: Text(localizationOptions.dialogReportModeCancel),
          onPressed: () => _onRejectReportClicked(context, report),
        ),
      ],
    );
  }

  Widget _buildMaterialDialog(Report report, BuildContext context) {
    // return WillPopScope(
    //   onWillPop: () async => false,
    //   child: AlertDialog(
    //     title: Text(localizationOptions.dialogReportModeTitle),
    //     content: Text(localizationOptions.dialogReportModeDescription),
    //     actions: <Widget>[
    //       FlatButton(
    //         child: Text(localizationOptions.dialogReportModeAccept),
    //         onPressed: () => _onAcceptReportClicked(context, report),
    //       ),
    //       FlatButton(
    //         child: Text(localizationOptions.dialogReportModeCancel),
    //         onPressed: () => _onCancelReportClicked(context, report),
    //       ),
    //
    //   ),
    // );
    return _MaterialDialog(
        localizationOptions,
        () => _onAcceptReportClicked(context, report),
        () => _onRejectReportClicked(context, report));
  }

  Future<ErrorStatus> _onAcceptReportClicked(
      BuildContext context, Report report) async {
    final errorStatus = await super.onActionConfirmed(report);
    if (errorStatus == ErrorStatus.COMPLETED) {
      Navigator.pop(context);
    } else {
      return errorStatus;
    }
  }

  void _onRejectReportClicked(BuildContext context, Report report) async {
    await super.onActionRejected(report);
    exit(1);
  }

  @override
  bool isContextRequired() {
    return true;
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.Web, PlatformType.Android, PlatformType.iOS];
}

class _MaterialDialog extends StatefulWidget {
  final LocalizationOptions _localizationOptions;

  const _MaterialDialog(localizationOptions, onAccept, onReject)
      : _localizationOptions = localizationOptions,
        _onAccept = onAccept,
        _onReject = onReject;

  final Future<ErrorStatus> Function() _onAccept;
  final Function() _onReject;

  @override
  _MaterialDialogState createState() => _MaterialDialogState();
}

class _MaterialDialogState extends State<_MaterialDialog> {
  Status _status = Status.INIT;
  String errorText = '';

  _accept() async {
    final errorStatus = await widget._onAccept();
    _handleError(errorStatus);
  }

  _reject() async {
    final errorStatus = await widget._onReject();
    _handleError(errorStatus);
  }

  _handleError(ErrorStatus errorStatus) {
    var errorMsg = 'Sorry, something went wrong';
    switch (errorStatus) {
      case ErrorStatus.NO_INTERNET:
        errorMsg = 'No internet. Please try again.';
        break;
      case ErrorStatus.TIMEOUT:
        errorMsg = 'Took too long. Please try again.';
        break;
      case ErrorStatus.UNKNOWN:
        errorMsg =
            'An unknown error occurred while trying to send the report. Please try again or restart the app.';
        break;
      default:
        break;
    }
    setState(() {
      _status = Status.ERROR;
      errorText = errorMsg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: Text(widget._localizationOptions.dialogReportModeTitle),
        content: Text(
          _status == Status.INIT
              ? widget._localizationOptions.dialogReportModeDescription
              : errorText,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              _status == Status.INIT
                  ? widget._localizationOptions.dialogReportModeAccept
                  : widget._localizationOptions.retry,
            ),
            onPressed: () => _accept(),
          ),
          FlatButton(
            child: Text(
              _status == Status.INIT
                  ? widget._localizationOptions.dialogReportModeCancel
                  : widget._localizationOptions.close,
            ),
            onPressed: () => _reject(),
          ),
        ],
      ),
    );
  }
}
