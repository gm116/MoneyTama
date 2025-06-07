class Pet {
  Mood mood;
  int health;

  Pet({
    required this.mood,
    this.health = 100,
  });

  void changeMood(Mood newMood) {
    mood = newMood;
  }

  void increaseHealth([int value = 10]) {
    health += value;
  }

  void decreaseHealth([int value = 10]) {
    health -= value;
    if (health < 0) health = 0;
  }
}

enum Mood {
  happy,
  content,
  normal,
  sad,
  hibernated,
}
