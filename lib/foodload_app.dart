import 'package:flutter/material.dart';
import 'package:foodload_flutter/app_theme.dart';
import 'package:foodload_flutter/routes.dart';
import 'package:foodload_flutter/ui/widgets/global_notification_wrapper.dart';

class FoodLoadApp extends StatelessWidget {
  final navigatorKey;

  const FoodLoadApp(this.navigatorKey);

  @override
  Widget build(BuildContext context) {
    return GlobalNotificationWrapper(
      child: MaterialApp(
        title: 'Foodload',
        navigatorKey: navigatorKey,
        theme: AppTheme.darkTheme,
        onGenerateRoute: routes,
      ),
    );
  }
}
