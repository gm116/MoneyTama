import 'package:flutter/material.dart';
import 'package:moneytama/presentation/di/di.dart';
import 'package:moneytama/presentation/main_app.dart';
import 'package:moneytama/tools/logger.dart';

void main() {
  setupDependencies();
  initLogger();
  runApp(const MyApp());
}
