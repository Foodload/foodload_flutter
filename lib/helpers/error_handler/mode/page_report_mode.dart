///
/// Copyright (C) 2020 Catcher
/// Licensed under the Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0)
/// see: https://github.com/jhomlala/catcher
///
/// No NOTICE file.
///
/// Modifications Copyright (C) 2021 Antonio Morales
///
///

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodload_flutter/helpers/error_handler/model/platform_type.dart';
import 'package:foodload_flutter/helpers/error_handler/model/report.dart';
import 'package:foodload_flutter/helpers/error_handler/model/report_mode.dart';
import 'package:foodload_flutter/helpers/error_handler/utils/error_handler_utils.dart';

class PageReportMode extends ReportMode {
  final bool showStackTrace;

  PageReportMode({
    this.showStackTrace = true,
  }) : assert(showStackTrace != null, "showStackTrace can't be null");

  @override
  void requestAction(Report report, BuildContext context) {
    _navigateToPageWidget(report, context);
  }

  void _navigateToPageWidget(Report report, BuildContext context) async {
    await Future<void>.delayed(Duration.zero);
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => PageWidget(this, report),
      ),
    );
  }

  @override
  bool isContextRequired() {
    return true;
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.Web, PlatformType.Android, PlatformType.iOS];
}

class PageWidget extends StatefulWidget {
  final PageReportMode pageReportMode;
  final Report report;

  PageWidget(this.pageReportMode, this.report);

  @override
  PageWidgetState createState() {
    return new PageWidgetState();
  }
}

class PageWidgetState extends State<PageWidget> {
  @override
  Widget build(BuildContext context) {
    return ErrorHandlerUtils.isCupertinoAppAncestor(context)
        ? _buildCupertinoPage()
        : _buildMaterialPage();
  }

  Widget _buildMaterialPage() {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.pageReportMode.localizationOptions.pageReportModeTitle),
      ),
      body: _buildInnerWidget(),
    );
  }

  Widget _buildCupertinoPage() {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle:
            Text(widget.pageReportMode.localizationOptions.pageReportModeTitle),
      ),
      child: SafeArea(
        child: _buildInnerWidget(),
      ),
    );
  }

  Widget _buildInnerWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget
                  .pageReportMode.localizationOptions.pageReportModeDescription,
              style: _getTextStyle(15),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _getStackTraceWidget(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text(widget
                    .pageReportMode.localizationOptions.pageReportModeAccept),
                onPressed: () => _onAcceptClicked(),
              ),
              FlatButton(
                child: Text(widget
                    .pageReportMode.localizationOptions.pageReportModeCancel),
                onPressed: () => _onCancelClicked(),
              ),
            ],
          )
        ],
      ),
    );
  }

  TextStyle _getTextStyle(double fontSize) {
    return TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        decoration: TextDecoration.none);
  }

  Widget _getStackTraceWidget() {
    if (widget.pageReportMode.showStackTrace) {
      var items = widget.report.stackTrace.toString().split("\n");
      return SizedBox(
        height: 300.0,
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(
              '${items[index]}',
              style: _getTextStyle(10),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }

  void _onAcceptClicked() {
    widget.pageReportMode.onActionConfirmed(widget.report);
    _closePage();
  }

  void _onCancelClicked() {
    widget.pageReportMode.onActionRejected(widget.report);
    _closePage();
  }

  void _closePage() {
    Navigator.of(context).pop();
  }
}
