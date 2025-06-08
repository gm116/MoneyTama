import 'package:flutter/material.dart';
import 'package:moneytama/presentation/screens/main_scaffold.dart';
import 'package:moneytama/presentation/screens/streak_screen.dart';

import '../tools/logger.dart';
import 'app_theme.dart';
import 'di/di.dart';
import 'navigation/navigation_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    logger.info('MyApp build');
    return MaterialApp(
    );
  }
}
