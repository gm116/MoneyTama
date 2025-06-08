import '../repository/shared_pref_repository.dart';

class SetPetColorsUseCase {
  final SharedPrefRepository repository;

  SetPetColorsUseCase(this.repository);

  Future<void> execute(String? mainColor, String? secondaryColor, String? tertiaryColor) async {
    final colors = [mainColor ?? '#FFC7E0', secondaryColor ?? '#A3DFFF', tertiaryColor ?? '#E6ADFF'];
    await repository.setPetColors(colors);
  }
}
