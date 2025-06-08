import 'package:flutter/material.dart';
import '../screens/main_screen.dart';

abstract class RouteNames {
  const RouteNames._();

  static const home = '/';
  static const streak = 'streak';
  static const customizePet = 'customizePet';
  // TODO add routes for each screen
}

class RoutesBuilder {
  static Route<Object?>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );

      case RouteNames.streak:
        return null;

      case RouteNames.customizePet:
        return null;
    }

    return null;
  }
}
