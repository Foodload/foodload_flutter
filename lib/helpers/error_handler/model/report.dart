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

import 'package:foodload_flutter/helpers/error_handler/model/platform_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Report {
  /// Error that has been caught
  final dynamic error;

  /// Stack trace of error
  final dynamic stackTrace;

  /// Time when it was caught
  final DateTime dateTime;

  /// Device info
  final Map<String, dynamic> deviceParameters;

  /// Application info
  final Map<String, dynamic> applicationParameters;

  /// Custom parameters passed to report
  final Map<String, dynamic> customParameters;

  /// FlutterErrorDetails data if present
  final FlutterErrorDetails errorDetails;

  /// Type of platform used
  final PlatformType platformType;

  /// Creates report instance
  Report(
      this.error,
      this.stackTrace,
      this.dateTime,
      this.deviceParameters,
      this.applicationParameters,
      this.customParameters,
      this.errorDetails,
      this.platformType);

  /// Creates json from current instance
  Map<String, dynamic> toJson({
    bool enableDeviceParameters = true,
    bool enableApplicationParameters = true,
    bool enableStackTrace = true,
    bool enableCustomParameters = false,
  }) {
    Map<String, dynamic> json = <String, dynamic>{
      "error": error.toString(),
      "customParameters": customParameters,
      "dateTime": dateTime.toIso8601String(),
      "platformType": describeEnum(platformType),
    };
    if (enableDeviceParameters) {
      json["deviceParameters"] = deviceParameters;
    }
    if (enableApplicationParameters) {
      json["applicationParameters"] = applicationParameters;
    }
    if (enableStackTrace) {
      json["stackTrace"] = stackTrace.toString();
    }
    if (enableCustomParameters) {
      json["customParameters"] = customParameters;
    }
    return json;
  }
}
