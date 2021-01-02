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

import 'package:foodload_flutter/helpers/error_handler/model/report.dart';
import 'package:foodload_flutter/helpers/error_handler/model/error_status.dart';

abstract class ReportModeAction {
  ///Code which should be triggered if report mode has been confirmed
  Future<ErrorStatus> onActionConfirmed(Report report);

  /// Code which should be triggered if report mode has been rejected
  Future<void> onActionRejected(Report report);
}
