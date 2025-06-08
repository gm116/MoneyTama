import 'package:flutter/material.dart';
import 'package:moneytama/presentation/screens/add_expense_screen.dart';
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
      navigatorKey: getIt<NavigationService>().navigatorKey,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case MainScaffold.routeName:
            return MaterialPageRoute(
                builder: (context) => const MainScaffold());
          case AddExpenseScreen.routeName:
            return MaterialPageRoute(
                builder: (context) => const AddExpenseScreen());
          default:
            return MaterialPageRoute(
                builder: (context) => const StreakScreen());
        }
      },
      debugShowCheckedModeBanner: false,
      title: 'MoneyTama',
      theme: AppTheme.theme(false),
      home: const StreakScreen(),
      routes: <String, WidgetBuilder>{
        MainScaffold.routeName:
            (BuildContext context) => const MainScaffold(),
        AddExpenseScreen.routeName:
            (BuildContext context) => const AddExpenseScreen(),
      },
    );
  }
}
