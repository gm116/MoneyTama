import 'package:moneytama/data/service/shared_pref_repository_impl.dart';
import 'package:moneytama/domain/entity/operation.dart';
import 'package:moneytama/presentation/di/di.dart';

import '../usecase/get_budget_usecase.dart';
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
    if (budget != null) {
      _increaseHealth(op.sum > budget.plannedAmount / 4 ? 20 : 10);
    }
    _setMood();
  }

  Future<void> disappoint(Expense op) async {
    SharedPrefRepositoryImpl rep = SharedPrefRepositoryImpl();
    Budget? budget = await rep.getBudget();
    if (budget != null) {
      _decreaseHealth(
        budget.plannedAmount - budget.currentBalance < 0 ? 10 : 0,
      );
      _decreaseHealth(!op.planned ? 10 : 0);
    }
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
  }

  void _decreaseHealth([int value = 5]) {
    _health -= value;
    if (_health < 0) _health = 0;
  }
}

enum Mood { happy, normal, sad }

enum PetColors {
  green("#00FF00"),
  blue("#0000FF"),
  red("#FF0000"),
  orange("#FFA500"),
  white("#FFFFFF"),
  pink("#FFC0CB");

  final String hexCode;

  const PetColors(this.hexCode);
}
