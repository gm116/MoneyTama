import 'package:flutter/material.dart';
import 'package:moneytama/domain/entity/pet.dart';
import 'package:moneytama/presentation/main_app.dart';
import 'package:moneytama/presentation/state/pet_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // TODO get pet from db to NOT crate it every time with default parameters
    ChangeNotifierProvider(
      create: (context) => PetNotifier(Pet()),
      child: MyApp(),
    ),
  );
}
