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

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodload_flutter/helpers/error_handler/mode/report_mode_action.dart';
import 'package:foodload_flutter/helpers/error_handler/model/application_profile.dart';
import 'package:foodload_flutter/helpers/error_handler/model/error_handler_options.dart';
import 'package:foodload_flutter/helpers/error_handler/model/exceptions.dart';
import 'package:foodload_flutter/helpers/error_handler/model/localization_options.dart';
import 'package:foodload_flutter/helpers/error_handler/model/platform_type.dart';
import 'package:foodload_flutter/helpers/error_handler/model/report.dart';
import 'package:foodload_flutter/helpers/error_handler/model/report_handler.dart';
import 'package:foodload_flutter/helpers/error_handler/model/report_mode.dart';
import 'package:foodload_flutter/helpers/error_handler/utils/error_handler_widget.dart';
import 'package:logging/logging.dart';
import 'package:package_info/package_info.dart';

import 'application_profile_manager.dart';

class ErrorHandler with ReportModeAction {
  static ErrorHandler _instance;
  static GlobalKey<NavigatorState> _navigatorKey;

  /// Root widget which will be ran
  final Widget rootWidget;

  ///Run app function which will be ran
  final void Function() runAppFunction;

  /// Instance of config used in release mode
  ErrorHandlerOptions releaseConfig;

  /// Instance of config used in debug mode
  ErrorHandlerOptions debugConfig;

  /// Instance of config used in profile mode
  ErrorHandlerOptions profileConfig;

  /// Should logs be enabled
  final bool enableLogger;

  /// Should run WidgetsFlutterBinding.ensureInitialized() during initialization.
  final bool ensureInitialized;

  final Logger _logger = Logger("Error Handler");
  ErrorHandlerOptions _currentConfig;
  Map<String, dynamic> _deviceParameters = <String, dynamic>{};
  Map<String, dynamic> _applicationParameters = <String, dynamic>{};
  List<Report> _cachedReports = [];
  LocalizationOptions _localizationOptions;

  /// Instance of navigator key
  static GlobalKey<NavigatorState> get navigatorKey {
    return _navigatorKey;
  }

  /// Builds instance
  ErrorHandler({
    this.rootWidget,
    this.runAppFunction,
    this.releaseConfig,
    this.debugConfig,
    this.profileConfig,
    this.enableLogger = true,
    this.ensureInitialized = false,
    GlobalKey<NavigatorState> navigatorKey,
  }) : assert(rootWidget != null || runAppFunction != null,
            "You need to provide rootWidget or runAppFunction") {
    _configure(navigatorKey);
  }

  void _configure(GlobalKey<NavigatorState> navigatorKey) {
    _instance = this;
    _configureNavigatorKey(navigatorKey);
    _configureLogger();
    _setupCurrentConfig();
    _setupErrorHooks();
    _setupReportModeActionInReportMode();

    _loadDeviceInfo();
    _loadApplicationInfo();

    if (_currentConfig.handlers.isEmpty) {
      _logger
          .warning("Handlers list is empty. Configure at least one handler to "
              "process error reports.");
    } else {
      _logger.fine("Error Handler configured successfully.");
    }
  }

  void _configureNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    if (navigatorKey != null) {
      _navigatorKey = navigatorKey;
    } else {
      _navigatorKey = GlobalKey<NavigatorState>();
    }
  }

  void _setupCurrentConfig() {
    switch (ApplicationProfileManager.getApplicationProfile()) {
      case ApplicationProfile.release:
        {
          _logger.fine("Using release config");
          if (releaseConfig != null) {
            _currentConfig = releaseConfig;
          } else {
            _currentConfig = ErrorHandlerOptions.getDefaultReleaseOptions();
          }
          break;
        }
      case ApplicationProfile.debug:
        {
          _logger.fine("Using debug config");
          if (debugConfig != null) {
            _currentConfig = debugConfig;
          } else {
            _currentConfig = ErrorHandlerOptions.getDefaultDebugOptions();
          }
          break;
        }
      case ApplicationProfile.profile:
        {
          _logger.fine("Using profile config");
          if (profileConfig != null) {
            _currentConfig = profileConfig;
          } else {
            _currentConfig = ErrorHandlerOptions.getDefaultProfileOptions();
          }
          break;
        }
    }
  }

  ///Update config after initialization
  void updateConfig({
    ErrorHandlerOptions debugConfig,
    ErrorHandlerOptions profileConfig,
    ErrorHandlerOptions releaseConfig,
  }) {
    if (debugConfig != null) {
      this.debugConfig = debugConfig;
    }
    if (profileConfig != null) {
      this.profileConfig = profileConfig;
    }
    if (releaseConfig != null) {
      this.releaseConfig = releaseConfig;
    }
    _setupCurrentConfig();
    _setupReportModeActionInReportMode();
    _localizationOptions = null;
  }

  void _setupReportModeActionInReportMode() {
    this._currentConfig.reportMode.setReportModeAction(this);
    this._currentConfig.explicitExceptionReportModesMap.forEach(
      (error, reportMode) {
        reportMode.setReportModeAction(this);
      },
    );
  }

  void _setupLocalizationsOptionsInReportMode() {
    this._currentConfig.reportMode.setLocalizationOptions(_localizationOptions);
    this._currentConfig.explicitExceptionReportModesMap.forEach(
      (error, reportMode) {
        reportMode.setLocalizationOptions(_localizationOptions);
      },
    );
  }

  Future _setupErrorHooks() async {
    FlutterError.onError = (FlutterErrorDetails details) async {
      _reportError(details.exception, details.stack, errorDetails: details);
    };

    ///Web doesn't have Isolate error listener support
    if (!ApplicationProfileManager.isWeb()) {
      Isolate.current.addErrorListener(new RawReceivePort((dynamic pair) async {
        var isolateError = pair as List<dynamic>;
        _reportError(
          isolateError.first.toString(),
          isolateError.last.toString(),
        );
      }).sendPort);
    }

    if (rootWidget != null) {
      _runZonedGuarded(() {
        runApp(rootWidget);
      });
    } else {
      _runZonedGuarded(() {
        runAppFunction();
      });
    }
  }

  void _runZonedGuarded(void Function() callback) {
    runZonedGuarded<Future<void>>(() async {
      if (ensureInitialized) {
        WidgetsFlutterBinding.ensureInitialized();
      }
      callback();
    }, (dynamic error, StackTrace stackTrace) {
      _reportError(error, stackTrace);
    });
  }

  void _configureLogger() {
    if (enableLogger) {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen(
        (LogRecord rec) {
          print(
              '[${rec.time} | ${rec.loggerName} | ${rec.level.name}] ${rec.message}');
        },
      );
    }
  }

  void _loadDeviceInfo() {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceInfo.androidInfo.then((androidInfo) {
        _loadAndroidParameters(androidInfo);
      });
    } else {
      deviceInfo.iosInfo.then((iosInfo) {
        _loadIosParameters(iosInfo);
      });
    }
  }

  void _loadAndroidParameters(AndroidDeviceInfo androidDeviceInfo) {
    _deviceParameters["id"] = androidDeviceInfo.id;
    _deviceParameters["androidId"] = androidDeviceInfo.androidId;
    _deviceParameters["board"] = androidDeviceInfo.board;
    _deviceParameters["bootloader"] = androidDeviceInfo.bootloader;
    _deviceParameters["brand"] = androidDeviceInfo.brand;
    _deviceParameters["device"] = androidDeviceInfo.device;
    _deviceParameters["display"] = androidDeviceInfo.display;
    _deviceParameters["fingerprint"] = androidDeviceInfo.fingerprint;
    _deviceParameters["hardware"] = androidDeviceInfo.hardware;
    _deviceParameters["host"] = androidDeviceInfo.host;
    _deviceParameters["isPhysicalDevice"] = androidDeviceInfo.isPhysicalDevice;
    _deviceParameters["manufacturer"] = androidDeviceInfo.manufacturer;
    _deviceParameters["model"] = androidDeviceInfo.model;
    _deviceParameters["product"] = androidDeviceInfo.product;
    _deviceParameters["tags"] = androidDeviceInfo.tags;
    _deviceParameters["type"] = androidDeviceInfo.type;
    _deviceParameters["versionBaseOs"] = androidDeviceInfo.version.baseOS;
    _deviceParameters["versionCodename"] = androidDeviceInfo.version.codename;
    _deviceParameters["versionIncremental"] =
        androidDeviceInfo.version.incremental;
    _deviceParameters["versionPreviewSdk"] =
        androidDeviceInfo.version.previewSdkInt;
    _deviceParameters["versionRelease"] = androidDeviceInfo.version.release;
    _deviceParameters["versionSdk"] = androidDeviceInfo.version.sdkInt;
    _deviceParameters["versionSecurityPatch"] =
        androidDeviceInfo.version.securityPatch;
  }

  void _loadIosParameters(IosDeviceInfo iosInfo) {
    _deviceParameters["model"] = iosInfo.model;
    _deviceParameters["isPhysicalDevice"] = iosInfo.isPhysicalDevice;
    _deviceParameters["name"] = iosInfo.name;
    _deviceParameters["identifierForVendor"] = iosInfo.identifierForVendor;
    _deviceParameters["localizedModel"] = iosInfo.localizedModel;
    _deviceParameters["systemName"] = iosInfo.systemName;
    _deviceParameters["utsnameVersion"] = iosInfo.utsname.version;
    _deviceParameters["utsnameRelease"] = iosInfo.utsname.release;
    _deviceParameters["utsnameMachine"] = iosInfo.utsname.machine;
    _deviceParameters["utsnameNodename"] = iosInfo.utsname.nodename;
    _deviceParameters["utsnameSysname"] = iosInfo.utsname.sysname;
  }

  void _loadApplicationInfo() {
    _applicationParameters["environment"] =
        describeEnum(ApplicationProfileManager.getApplicationProfile());

    ///There is no package info web implementation
    if (!ApplicationProfileManager.isWeb()) {
      PackageInfo.fromPlatform().then((packageInfo) {
        _applicationParameters["version"] = packageInfo.version;
        _applicationParameters["appName"] = packageInfo.appName;
        _applicationParameters["buildNumber"] = packageInfo.buildNumber;
        _applicationParameters["packageName"] = packageInfo.packageName;
      });
    }
  }

  ///We need to setup localizations lazily because context needed to setup these
  ///localizations can be used after app was build for the first time.
  void _setupLocalization() {
    Locale locale = Locale("en", "US");
    if (_isContextValid()) {
      BuildContext context = _getContext();
      if (context != null) {
        locale = Localizations.localeOf(context);
      }
      if (_currentConfig.localizationOptions != null) {
        for (var options in _currentConfig.localizationOptions) {
          if (options.languageCode.toLowerCase() ==
              locale.languageCode.toLowerCase()) {
            _localizationOptions = options;
          }
        }
      }
    }

    if (_localizationOptions == null) {
      _localizationOptions =
          _getDefaultLocalizationOptionsForLanguage(locale.languageCode);
    }
    _setupLocalizationsOptionsInReportMode();
  }

  LocalizationOptions _getDefaultLocalizationOptionsForLanguage(
      String language) {
    switch (language.toLowerCase()) {
      case "en":
        return LocalizationOptions.buildDefaultEnglishOptions();
      default:
        return LocalizationOptions.buildDefaultEnglishOptions();
    }
  }

  /// Report checked error (error caught in try-catch block). Error Handler will treat
  /// this as normal exception and pass it to handlers.
  static void reportCheckedError(dynamic error, dynamic stackTrace) {
    if (error == null) {
      error = "undefined error";
    }
    if (stackTrace == null) {
      stackTrace = StackTrace.current;
    }
    _instance._reportError(error, stackTrace);
  }

  void _reportError(dynamic error, dynamic stackTrace,
      {FlutterErrorDetails errorDetails}) async {
    if (_localizationOptions == null) {
      _logger.info("Setup localization lazily!");
      _setupLocalization();
    }

    Report report = Report(
        error,
        stackTrace,
        DateTime.now(),
        _deviceParameters,
        _applicationParameters,
        _currentConfig.customParameters,
        errorDetails,
        _getPlatformType());
    _cachedReports.add(report);
    ReportMode reportMode =
        _getReportModeFromExplicitExceptionReportModeMap(error);
    if (reportMode != null) {
      _logger.info("Using explicit report mode for error");
    } else {
      reportMode = _currentConfig.reportMode;
    }
    if (!isReportModeSupportedInPlatform(report, reportMode)) {
      _logger.warning(
          "$reportMode in not supported for ${describeEnum(report.platformType)} platform");
      return;
    }

    if (reportMode.isContextRequired()) {
      if (_isContextValid()) {
        reportMode.requestAction(report, _getContext());
      } else {
        _logger.warning(
            "Couldn't use report mode because you didn't provide navigator key. Add navigator key to use this report mode.");
      }
    } else {
      reportMode.requestAction(report, null);
    }
  }

  /// Check if given report mode is enabled in current platform. Only supported
  /// handlers in given report mode can be used.
  bool isReportModeSupportedInPlatform(Report report, ReportMode reportMode) {
    if (reportMode == null) {
      return false;
    }
    if (reportMode.getSupportedPlatforms() == null ||
        reportMode.getSupportedPlatforms().isEmpty) {
      return false;
    }
    return reportMode.getSupportedPlatforms().contains(report.platformType);
  }

  ReportMode _getReportModeFromExplicitExceptionReportModeMap(dynamic error) {
    var errorName = error != null ? error.toString().toLowerCase() : "";
    ReportMode reportMode;
    _currentConfig.explicitExceptionReportModesMap.forEach((key, value) {
      if (errorName.contains(key.toLowerCase())) {
        reportMode = value;
        return;
      }
    });
    return reportMode;
  }

  ReportHandler _getReportHandlerFromExplicitExceptionHandlerMap(
      dynamic error) {
    var errorName = error != null ? error.toString().toLowerCase() : "";
    ReportHandler reportHandler;
    _currentConfig.explicitExceptionHandlersMap.forEach((key, value) {
      if (errorName.contains(key.toLowerCase())) {
        reportHandler = value;
        return;
      }
    });
    return reportHandler;
  }

  @override
  Future<void> onActionConfirmed(Report report) async {
    ReportHandler reportHandler =
        _getReportHandlerFromExplicitExceptionHandlerMap(report.error);

    if (reportHandler != null) {
      _logger.info("Using explicit report handler");
      await _handleReport(report, reportHandler);
      return;
    }

    for (ReportHandler handler in _currentConfig.handlers) {
      await _handleReport(report, handler);
    }
  }

  Future<void> _handleReport(Report report, ReportHandler reportHandler) async {
    if (!isReportHandlerSupportedInPlatform(report, reportHandler)) {
      _logger.warning(
          "$reportHandler in not supported for ${describeEnum(report.platformType)} platform");
      throw NotSupportedException(
          '$reportHandler in not supported for ${describeEnum(report.platformType)} platform');
    }

    try {
      await reportHandler
          .handle(report)
          .timeout(Duration(milliseconds: _currentConfig.handlerTimeout));
      _cachedReports.remove(report);
      _logger.info("Report result: Done");
    } on TimeoutException catch (_) {
      _logger.warning(
          "${reportHandler.toString()} failed to report error because of timeout");
      _logger.info("Report result: Fail (Timeout)");
      throw TimeoutException(
          'Failed to report error because it took too long. Please try again.');
    } on ErrorHandlerException catch (error) {
      _logger.warning("${reportHandler.toString()} failed to report error");
      _logger.warning(
          "Error occurred in ${reportHandler.toString()}: ${error.toString()}");
      _logger.info("Report result: Fail");
      rethrow;
    } catch (error) {
      _logger.warning(
          "Error occurred in ${reportHandler.toString()}: ${error.toString()}");
      throw UnknownException(
          'An unknown error occurred. Please try again or restart the app');
    }
  }

  /// Checks is report handler is supported in given platform. Only supported
  /// report handlers in given platform can be used.
  bool isReportHandlerSupportedInPlatform(
      Report report, ReportHandler reportHandler) {
    if (reportHandler == null) {
      return false;
    }
    if (reportHandler.getSupportedPlatforms() == null ||
        reportHandler.getSupportedPlatforms().isEmpty) {
      return false;
    }
    return reportHandler.getSupportedPlatforms().contains(report.platformType);
  }

  @override
  Future<void> onActionRejected(Report report) async {
    _cachedReports.remove(report);
  }

  BuildContext _getContext() {
    return navigatorKey.currentState.overlay.context;
  }

  bool _isContextValid() {
    return navigatorKey?.currentState?.overlay != null;
  }

  /// Get currently used config.
  ErrorHandlerOptions getCurrentConfig() {
    return _currentConfig;
  }

  /// Send text exception. Used to test Error Handler's configuration.
  static void sendTestException() {
    throw FormatException("Test exception generated by Error Handler");
  }

  /// Add default error widget which replaces red screen of death (RSOD).
  static void addDefaultErrorWidget(
      {bool showStacktrace = true,
      String title = "An application error has occurred",
      String description =
          "There was unexpected situation in application. Application has been "
              "able to recover from error state.",
      double maxWidthForSmallMode = 150}) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return ErrorHandlerWidget(
        details: details,
        showStacktrace: showStacktrace,
        title: title,
        description: description,
        maxWidthForSmallMode: maxWidthForSmallMode,
      );
    };
  }

  PlatformType _getPlatformType() {
    if (ApplicationProfileManager.isAndroid()) {
      return PlatformType.Android;
    }
    if (ApplicationProfileManager.isIos()) {
      return PlatformType.iOS;
    }
    return PlatformType.Unknown;
  }
}
