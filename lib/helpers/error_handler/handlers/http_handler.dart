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

import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:foodload_flutter/helpers/error_handler/model/exceptions.dart';
import 'package:foodload_flutter/helpers/error_handler/model/http_request_type.dart';
import 'package:foodload_flutter/helpers/error_handler/model/platform_type.dart';
import 'package:foodload_flutter/helpers/error_handler/model/report.dart';
import 'package:foodload_flutter/helpers/error_handler/model/report_handler.dart';
import 'package:foodload_flutter/helpers/error_handler/utils/error_handler_utils.dart';

import 'package:logging/logging.dart';

class HttpHandler extends ReportHandler {
  final Dio _dio = Dio();
  final Logger _logger = Logger("HttpHandler");

  final HttpRequestType requestType;
  final Uri endpointUri;
  final Map<String, dynamic> headers;
  final int requestTimeout;
  final int responseTimeout;
  final bool printLogs;
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;

  HttpHandler(
    this.requestType,
    this.endpointUri, {
    Map<String, dynamic> headers,
    this.requestTimeout = 5000,
    this.responseTimeout = 5000,
    this.printLogs = false,
    this.enableDeviceParameters = true,
    this.enableApplicationParameters = true,
    this.enableStackTrace = true,
    this.enableCustomParameters = false,
  })  : assert(requestType != null, "requestType can't be null"),
        assert(endpointUri != null, "endpointUri can't be null"),
        assert(requestTimeout != null, "requestTimeout can't be null"),
        assert(responseTimeout != null, "responseTimeout can't be null"),
        assert(printLogs != null, "printLogs can't be null"),
        assert(enableDeviceParameters != null,
            "enableDeviceParameters can't be null"),
        assert(enableApplicationParameters != null,
            "enableApplicationParameters can't be null"),
        assert(enableStackTrace != null, "enableStackTrace can't be null"),
        assert(enableCustomParameters != null,
            "enableCustomParameters can't be null"),
        this.headers = headers != null ? headers : <String, dynamic>{};

  @override
  Future<void> handle(Report error) async {
    if (error.platformType != PlatformType.Web) {
      if (!(await ErrorHandlerUtils.isInternetConnectionAvailable())) {
        _printLog("No internet connection available");
        throw NoInternetException('No internet connection available.');
      }
    }

    if (requestType == HttpRequestType.POST) {
      await _sendPost(error);
    }
  }

  Future<void> _sendPost(Report error) async {
    try {
      var json = error.toJson(
          enableDeviceParameters: enableDeviceParameters,
          enableApplicationParameters: enableApplicationParameters,
          enableStackTrace: enableStackTrace,
          enableCustomParameters: enableCustomParameters);
      HashMap<String, dynamic> mutableHeaders = HashMap<String, dynamic>();
      if (headers != null) {
        mutableHeaders.addAll(headers);
      }
      Options options = Options(
          sendTimeout: requestTimeout,
          receiveTimeout: responseTimeout,
          headers: mutableHeaders);
      _printLog("Calling: ${endpointUri.toString()}");
      Response response = await _dio.post<dynamic>(endpointUri.toString(),
          data: json, options: options);
      _printLog(
          "HttpHandler response status: ${response.statusCode} body: ${response.data}");
    } catch (error, stackTrace) {
      _printLog("HttpHandler error: $error, stackTrace: $stackTrace");
      throw FailException(
          'Failed to send the error log. Please try again or restart the application.');
    }
  }

  void _printLog(String log) {
    if (printLogs) {
      _logger.info(log);
    }
  }

  @override
  String toString() {
    return 'HttpHandler';
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.Web, PlatformType.Android, PlatformType.iOS];
}
