import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneytama/domain/entity/pet.dart';
import 'package:moneytama/presentation/di/di.dart';
import 'package:moneytama/presentation/main_app.dart';
import 'package:moneytama/presentation/state/pet_notifier.dart';
import 'package:moneytama/tools/logger.dart';
import 'package:provider/provider.dart';

void main() {
  setupDependencies();
  initLogger();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PetNotifier>(
          create: (_) => PetNotifier(Pet()),
        ),
      ],
      child: MyApp(),
    ),
  );
}
