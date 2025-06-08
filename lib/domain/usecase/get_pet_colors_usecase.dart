import 'package:moneytama/domain/repository/shared_pref_repository.dart';

class GetPetColorsUseCase {
  final SharedPrefRepository repository;

  GetPetColorsUseCase(this.repository);

  Future<List<String>> execute() async {
    final colors = await repository.getPetColors();
    if (colors.length != 3) {
      // set default colors if the list is not valid
      repository.setPetColors(['#FFC7E0', '#A3DFFF', '#E6ADFF']);
      return ['#FFC7E0', '#A3DFFF', '#E6ADFF'];
    }
    return colors;
  }
}
