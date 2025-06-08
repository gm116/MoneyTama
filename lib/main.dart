import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneytama/domain/entity/pet.dart';
import 'package:moneytama/presentation/di/di.dart';
import 'package:moneytama/presentation/main_app.dart';
import 'package:moneytama/presentation/state/pet_notifier.dart';
import 'package:moneytama/tools/logger.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLogger();
  setupDependencies();
  await initializeDateFormatting('ru_RU', null);
  Intl.defaultLocale = 'ru_RU';
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
