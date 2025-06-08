import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneytama/presentation/navigation/navigation_service.dart';
import 'package:moneytama/presentation/state/pet_notifier.dart';
import 'package:provider/provider.dart';

import '../views/operations_list.dart';
import '../views/pet_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

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
    final PetNotifier notifier = Provider.of<PetNotifier>(context);
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
        child: Column(
          children: [
            _CustomizePetButton(),
            PetWidget(),
            RecentOperationsList(),
            _AddOperationButton(),
          ],
        ),
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
        // todo: а где routenames??
        // Navigator.of(context).pushNamed(RouteNames.customizePet);
      },
      child: Center(
        child: SvgPicture.asset(
          "assets/svg/customize_pet_icon.svg",
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}


class _AddOperationButton extends StatelessWidget {
  const _AddOperationButton({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
