import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/get_pet_colors_usecase.dart';
import '../../../domain/usecase/set_pet_colors_usecase.dart';
import '../../../tools/logger.dart';
import 'decoration_state.dart';

class DecorationCubit extends Cubit<DecorationState> {
  final GetPetColorsUseCase getPetColorsUseCase;
  final SetPetColorsUseCase setPetColorsUseCase;

  DecorationCubit({
    required this.getPetColorsUseCase,
    required this.setPetColorsUseCase,
  }) : super(DecorationLoading()) {
    loadPet();
  }

  Future<void> loadPet() async {
    emit(DecorationLoading());
    try {
      final colors = await getPetColorsUseCase.execute();
      final mainColor = colors[0];
      final secondaryColor = colors[1];
      final accentColor = colors[2];

      String svgString = await rootBundle.loadString('assets/svg/pet.svg');

      final petString = svgString
          .replaceAll('#COLOR_MAIN', mainColor)
          .replaceAll('#COLOR_SECONDARY', secondaryColor)
          .replaceAll('#COLOR_ACCENT', accentColor);
      emit(DecorationInfo(petString));
      logger.info('Pet: $petString');
    } catch (error) {
      logger.severe('Error loading pet: $error');
      emit(DecorationError());
    }
  }
}
