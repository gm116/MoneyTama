import 'package:flutter/material.dart';
import 'package:moneytama/presentation/screens/add_expense_screen.dart';
import 'package:moneytama/presentation/screens/settings_screen.dart';

import 'decoration_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';

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
      HomeScreen(updateIndex: _updateIndex),
      HistoryScreen(updateIndex: _updateIndex),
      DecorationScreen(updateIndex: _updateIndex),
      SettingsScreen(updateIndex: _updateIndex),
      AddExpenseScreen(updateIndex: _updateIndex),
    ];
  }

  void _updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _updateIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Дом',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'История',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.color_lens),
            label: 'Украшение',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}
