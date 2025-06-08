import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneytama/presentation/navigation/navigation_service.dart';
import 'package:moneytama/presentation/screens/decoration_screen.dart';
import 'package:moneytama/presentation/state/pet_notifier.dart';
import 'package:provider/provider.dart';

import '../di/di.dart';
import '../views/operations_list.dart';
import '../views/pet_widget.dart';
import 'add_operation_screen.dart';

class MainScreen extends StatefulWidget {
  final Function(int) updateIndex;

  const MainScreen({super.key, required this.updateIndex});

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    PetNotifier notifier = Provider.of<PetNotifier>(context);
    return Column(
      children: [
        Row(
          children: [
            _CustomizePetButton(updateIndex: widget.updateIndex),
            Expanded(
              child: Text(
                notifier.pet.name,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "${notifier.pet.health} / 100",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.favorite, color: Colors.purple, size: 30),
            const SizedBox(width: 20),
          ],
        ),
        PetWidget(width: screenWidth, height: screenHeight / 4.1),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Row(
            children: [
              Expanded(
                child: _GoToHistoryButton(updateIndex: widget.updateIndex),
              ),
              const SizedBox(width: 20),
              SizedBox(width: 50, height: 50, child: _AddOperationButton()),
            ],
          ),
        ),
        RecentOperationsList(
          limit: 2,
          width: screenWidth,
          height: screenHeight / 2.8,
        ),
      ],
    );
  }
}

class _CustomizePetButton extends StatelessWidget {
  final Function(int) updateIndex;

  const _CustomizePetButton({required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        updateIndex(2);
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        minimumSize: const Size(40, 40),
      ),
      child: SizedBox(
        height: 30,
        width: 30,
        child: SvgPicture.asset("assets/svg/customize_pet_icon.svg"),
      ),
    );
  }
}

class _AddOperationButton extends StatelessWidget {
  const _AddOperationButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        getIt<NavigationService>().navigateTo(AddOperationScreen.routeName);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: const Center(child: Icon(Icons.add, size: 15)),
    );
  }
}

class _GoToHistoryButton extends StatelessWidget {
  final Function(int) updateIndex;

  const _GoToHistoryButton({required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        updateIndex(1);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: const Text("Перейти в историю"),
    );
  }
}
