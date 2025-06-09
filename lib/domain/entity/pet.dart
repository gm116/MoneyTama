import 'package:moneytama/data/service/shared_pref_repository_impl.dart';
import 'package:moneytama/domain/entity/operation.dart';

import 'budget.dart';

class Pet {
  Mood _mood;
  int _health;
  String _name;
  PetColors _color;

  Pet()
    : _color = PetColors.green,
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
    _health = health;
    _setMood();
  }
}

enum Mood { happy, normal, sad }

enum PetColors {
  green("#60D5AC", "#00AB6F", "#006F48"),
  blue("#6C8CD5", "#1240AB", "#06266F"),
  red("#FE7276", "#FE3F44", "#A40004"),
  orange("#FF9500", "#FFB040", "#FFC573"),
  purple("#B365D4", "#4E026E", "#7908AA"),
  pink("#E768AD", "#CE0071", "#860049");

  final String main;
  final String secondary;
  final String accent;

  const PetColors(this.main, this.secondary, this.accent);


}
