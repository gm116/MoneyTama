import 'package:flutter/services.dart';

class PetPainter {
  Future<String> getColoredPet(
      String filePath,
      String mainColor,
      String secondaryColor,
      String accentColor,
      ) async {
    String svgString = await rootBundle.loadString(filePath);
    return svgString
        .replaceAll('#COLOR_MAIN', mainColor)
        .replaceAll('#COLOR_SECONDARY', secondaryColor)
        .replaceAll('#COLOR_ACCENT', accentColor);
  }
}
