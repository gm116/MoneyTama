import 'package:moneytama/data/service/shared_pref_repository_impl.dart';
import 'package:moneytama/domain/entity/operation.dart';

import 'budget.dart';

class Pet {
  Mood _mood;
  int _health;
  String _name;
  PetColors _color;

  Pet()
    : _color = PetColors.pastel,
      _name = "Tama",
      _health = 100,
      _mood = Mood.happy;

  String get name => _name;

  PetColors get color => _color;

  Mood get mood => _mood;

  int get health => _health;

  set name(String value) {
    if (value.isNotEmpty) {
      _name = value;
    } else {
      throw ArgumentError("Name can't be empty");
    }
  }

  set color(PetColors value) {
    _color = value;
  }

  Future<void> cheerUp(Income op) async {
    SharedPrefRepositoryImpl rep = SharedPrefRepositoryImpl();
    Budget? budget = await rep.getBudget();
    if (budget != null && op.sum > budget.plannedAmount) {
      _increaseHealth(10);
    }
    _increaseHealth(10);
    _setMood();
  }

  Future<void> disappoint(Expense op) async {
    SharedPrefRepositoryImpl rep = SharedPrefRepositoryImpl();
    Budget? budget = await rep.getBudget();
    if (budget != null) {
      _decreaseHealth(
        budget.plannedAmount - budget.currentBalance < 0 ? 10 : 0,
      );
    }
    _decreaseHealth(!op.planned ? 10 : 0);
    _setMood();
  }

  void _setMood() {
    if (health >= 66) {
      _mood = Mood.happy;
    } else if (health >= 33) {
      _mood = Mood.normal;
    } else {
      _mood = Mood.sad;
    }
  }

  void _increaseHealth([int value = 5]) {
    _health += value;
    if (_health > 100) _health = 100;
  }

  void _decreaseHealth([int value = 5]) {
    _health -= value;
    if (_health < 0) _health = 0;
    if (_health > 100) _health = 100;
  }

  void setHealth(int petHealth) {
    _health = petHealth;
    _setMood();
  }
}

enum Mood { happy, normal, sad }

enum PetColors {
  pastel("#FFC7E0", "#A3DFFF", "#E6ADFF"),
  mintcandy("#cce3de", "#fb6f92", "#94d2bd"),
  red("#dde5b6", "#ff9f1c", "#8fb996"),
  orange("#bee3db", "#758e4f", "#0f8b8d"),
  purple("#ffe1a8", "#b83232", "#f35850"),
  pink("#fdca40", "#8f2d56", "#f79824");

  final String main;
  final String secondary;
  final String accent;

  const PetColors(this.main, this.secondary, this.accent);


}
