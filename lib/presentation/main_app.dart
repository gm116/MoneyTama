import 'package:flutter/material.dart';
import 'package:moneytama/presentation/screens/add_operation_screen.dart';
import 'package:moneytama/presentation/screens/main_scaffold.dart';
import 'package:moneytama/presentation/screens/streak_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moneytama/presentation/state/locale_provider.dart';
import 'package:provider/provider.dart';

import '../tools/logger.dart';
import 'app_theme.dart';
import 'di/di.dart';
import 'navigation/navigation_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    logger.info('MyApp build');
    return MaterialApp(
      navigatorKey: getIt<NavigationService>().navigatorKey,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case MainScaffold.routeName:
            return MaterialPageRoute(
                builder: (context) => const MainScaffold());
          case AddOperationScreen.routeName:
            return MaterialPageRoute(
                builder: (context) => const AddOperationScreen());
          default:
            return MaterialPageRoute(
                builder: (context) => const StreakScreen());
        }
      },
      locale: locale,
      debugShowCheckedModeBanner: false,
      title: 'MoneyTama',
      theme: AppTheme.theme(false),
      home: const StreakScreen(),
      routes: <String, WidgetBuilder>{
        MainScaffold.routeName:
            (BuildContext context) => const MainScaffold(),
        AddOperationScreen.routeName:
            (BuildContext context) => const AddOperationScreen(),
      },
      // ---------------------------- Локализация ----------------------------
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
    );
  }
}