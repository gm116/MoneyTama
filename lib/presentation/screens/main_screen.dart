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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.local_fire_department, color: Colors.orange),
            onPressed: () {
              Navigator.of(context).pushNamed('/streak');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(children: [_CustomizePetButton(), Text(
            notifier.pet.name
          )]),
          PetWidget(width: screenWidth, height: screenHeight / 3),
          RecentOperationsList(limit: 2, width: screenWidth, height: 310),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(child: _GoToHistoryButton()),
                const SizedBox(width: 20),
                SizedBox(width: 50, height: 50, child: _AddOperationButton()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomizePetButton extends StatelessWidget {
  const _CustomizePetButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {

      },
      style: ElevatedButton.styleFrom(shape: const CircleBorder()),
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
  const _GoToHistoryButton();

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
      child: const Text("Перейти в историю"),
    );
  }
}
