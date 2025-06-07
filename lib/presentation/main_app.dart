import 'package:flutter/material.dart';
import 'package:moneytama/presentation/screens/home_screen.dart';

import 'app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme(false),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
