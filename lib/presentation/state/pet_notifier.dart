import 'package:flutter/cupertino.dart';
import '../../domain/entity/pet.dart';

class PetNotifier extends ChangeNotifier {
  final Pet _pet;

  PetNotifier(this._pet);

  Pet get pet {
    notifyListeners();
    return _pet;
  }
}
