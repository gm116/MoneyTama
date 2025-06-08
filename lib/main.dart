import 'package:flutter/material.dart';
import 'package:moneytama/domain/entity/pet.dart';
import 'package:moneytama/presentation/di/di.dart';
import 'package:moneytama/presentation/main_app.dart';
import 'package:moneytama/presentation/state/locale_provider.dart';
import 'package:moneytama/presentation/state/pet_notifier.dart';
import 'package:moneytama/tools/logger.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLogger();
  setupDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PetNotifier>(
          create: (_) => PetNotifier(Pet()),
        ),
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}
