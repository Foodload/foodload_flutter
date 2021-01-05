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
import 'package:foodload_flutter/helpers/error_handler/model/report.dart';

abstract class ReportHandler {
  /// Method called when report has been accepted by user
  Future<void> handle(Report error);

  /// Get list of supported platforms
  List<PlatformType> getSupportedPlatforms();
}
