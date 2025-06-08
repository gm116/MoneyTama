import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../state/pet_notifier.dart';

class PetWidget extends StatefulWidget {
  const PetWidget({super.key});

  @override
  State<StatefulWidget> createState() => PetWidgetState();
}


// TODO pet widget
class PetWidgetState extends State<PetWidget> {
  @override
  Widget build(BuildContext context) {
    PetNotifier notifier = Provider.of<PetNotifier>(context);
    return SvgPicture.asset(
      "assets/svg/pet-cat-svgrepo-com.svg",
      height: 200,
      width: 200,
    );
  }
}