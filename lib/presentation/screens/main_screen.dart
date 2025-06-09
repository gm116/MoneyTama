import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneytama/domain/entity/pet.dart';
import 'package:moneytama/presentation/navigation/navigation_service.dart';
import 'package:moneytama/presentation/screens/add_operation_screen.dart';
import 'package:moneytama/presentation/state/pet_notifier.dart';
import 'package:moneytama/presentation/views/operations_list.dart';
import 'package:moneytama/presentation/views/swaying_svg.dart';
import 'package:provider/provider.dart';

import '../../tools/pet_painter.dart';
import '../di/di.dart';

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
    final Size screenSize   = MediaQuery.of(context).size;
    final double screenWidth  = screenSize.width;
    final double screenHeight = screenSize.height;
    final PetNotifier notifier = Provider.of<PetNotifier>(context);


    final String filePath = switch(notifier.pet.mood) {
      Mood.happy =>  'assets/svg/pet.svg',
      Mood.normal => 'assets/svg/pet-normal.svg',
      Mood.sad => 'assets/svg/pet-sad.svg',
    };

    final Future<String> petSvgFuture = PetPainter().getColoredPet(
      filePath,
      notifier.pet.color.main,
      notifier.pet.color.secondary,
      notifier.pet.color.accent,
    );

    return Column(
      children: [
        Row(
          children: [
            _CustomizePetButton(updateIndex: widget.updateIndex),
            Expanded(
              child: Text(
                notifier.pet.name,
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
        FutureBuilder<String>(
          future: petSvgFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: SizedBox(
                  width: screenWidth,
                  height: screenHeight / 4.1,
                  child: SwayingSvg(svgString: snapshot.data!, width: screenWidth, height: screenHeight / 4.1),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Ошибка загрузки изображения'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Row(
            children: [
              Expanded(child: _GoToHistoryButton(updateIndex: widget.updateIndex)),
              const SizedBox(width: 20),
              SizedBox(width: 50, height: 50, child: _AddOperationButton()),
            ],
          ),
        ),
        RecentOperationsList(
          limit: 2,
          width: screenWidth,
          height: screenHeight / 3.1,
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
    final l10n = AppLocalizations.of(context)!;
    return ElevatedButton(
      onPressed: () {
        updateIndex(1);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: Text(l10n.history),
    );
  }
}
