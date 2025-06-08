import 'package:flutter/services.dart';

class PetPainter {
  Future<String> getColoredPet(String mainColor, String secondaryColor, String accentColor) async {
    String svgString = await rootBundle.loadString('assets/svg/pet.svg');

    return svgString
        .replaceAll('#COLOR_MAIN', mainColor)
        .replaceAll('#COLOR_SECONDARY', secondaryColor)
        .replaceAll('#COLOR_ACCENT', accentColor);
  }
}
