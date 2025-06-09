import 'package:flutter/material.dart';
import 'package:moneytama/presentation/screens/main_screen.dart';
import 'package:moneytama/presentation/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'decoration_screen.dart';
import 'history_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  static const String routeName = '/main';

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      MainScreen(updateIndex: _updateIndex),
      HistoryScreen(updateIndex: _updateIndex),
      DecorationScreen(updateIndex: _updateIndex),
      SettingsScreen(updateIndex: _updateIndex),
    ];
  }

  void _updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? l10n.main_home
              : _currentIndex == 1
              ? l10n.history
              : _currentIndex == 2
              ? l10n.decoration_title
              : l10n.settings_title,
        ),
      ),
      body: Padding(padding: const EdgeInsets.all(8.0), child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _updateIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.main_home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: l10n.history,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.color_lens),
            label: l10n.decoration,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings_title,
          ),
        ],
      ),
    );
  }
}