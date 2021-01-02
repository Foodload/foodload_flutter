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

class LocalizationOptions {
  final String languageCode;
  final String notificationReportModeTitle;
  final String notificationReportModeContent;

  final String dialogReportModeTitle;
  final String dialogReportModeDescription;
  final String dialogReportModeAccept;
  final String dialogReportModeCancel;

  final String pageReportModeTitle;
  final String pageReportModeDescription;
  final String pageReportModeAccept;
  final String pageReportModeCancel;

  final String retry;
  final String close;

  LocalizationOptions(
    this.languageCode, {
    this.notificationReportModeTitle = "Error occurred",
    this.notificationReportModeContent =
        "Unexpected error occurred in application. A report has been sent to our developers.",
    this.dialogReportModeTitle = "Error occurred",
    this.dialogReportModeDescription:
        'Unexpected error occurred in application. A report is ready to be sent to our developers. Please click Accept to send the error report.',
    this.dialogReportModeAccept: 'Accept',
    this.dialogReportModeCancel: 'Reject',
    this.pageReportModeTitle = "Error occurred",
    this.pageReportModeDescription =
        "Unexpected error occurred in application. A report is ready to be sent to our developers. Please click Accept to send the error report.",
    this.pageReportModeAccept = "Accept",
    this.pageReportModeCancel = "Reject",
    this.retry = "Retry",
    this.close = "Close",
  });

  static LocalizationOptions buildDefaultEnglishOptions() {
    return LocalizationOptions("en");
  }
}
