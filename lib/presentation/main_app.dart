import 'package:flutter/material.dart';
import 'package:moneytama/presentation/screens/home_screen.dart';

import 'app_theme.dart';
import 'navigation/navigation_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyTama',
      theme: AppTheme.theme(false),
      initialRoute: RouteNames.home,
      onGenerateRoute: RoutesBuilder.onGenerateRoute,
    );
  }
}
