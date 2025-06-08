import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneytama/domain/entity/pet.dart';
import 'package:provider/provider.dart';

import '../state/pet_notifier.dart';

class PetWidget extends StatefulWidget {
  final double width;
  final double height;

  const PetWidget({super.key, required this.width, required this.height});

  @override
  State<StatefulWidget> createState() => PetWidgetState();
}

class PetWidgetState extends State<PetWidget> {
  @override
  Widget build(BuildContext context) {
    PetNotifier notifier = Provider.of<PetNotifier>(context);
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: switch (notifier.pet.mood) {
        Mood.happy => SvgPicture.asset("assets/svg/pet_happy.svg"),
        Mood.normal => SvgPicture.asset("assets/svg/pet-cat-svgrepo-com.svg"),
        Mood.sad => SvgPicture.asset("assets/svg/pet-cat-svgrepo-com.svg"),
      },
    );
  }
}
