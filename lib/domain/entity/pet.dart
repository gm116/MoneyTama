class Pet {
  Mood _mood;
  int _health;
  String _name;
  PetColors _color;

  Pet()
    : _color = PetColors.green,
      _name = "Tama",
      _health = 10,
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

  void cheerUp([int value = 5]) {
    _increaseHealth(value);
    _setMood();
  }

  void disappoint([int value = 5]) {
    _decreaseHealth(value);
    _setMood();
  }

  void _setMood() {
    if (health >= 80) {
      _mood = Mood.happy;
    } else if (health >= 60) {
      _mood = Mood.content;
    } else if (health >= 40) {
      _mood = Mood.normal;
    } else if (health > 5) {
      _mood = Mood.sad;
    } else {
      _mood = Mood.hibernated;
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

enum Mood { happy, content, normal, sad, hibernated }

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
