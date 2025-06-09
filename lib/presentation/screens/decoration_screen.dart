import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneytama/domain/entity/pet.dart';
import 'package:moneytama/presentation/cubit/decoration/decoration_cubit.dart';
import 'package:moneytama/presentation/cubit/decoration/decoration_state.dart';
import 'package:moneytama/presentation/di/di.dart';
import 'package:moneytama/presentation/views/swaying_svg.dart';
import 'package:moneytama/tools/logger.dart';
import 'package:moneytama/data/service/shared_pref_repository_impl.dart';
import 'package:provider/provider.dart';
import 'package:moneytama/presentation/state/pet_notifier.dart';

import '../../tools/logger.dart';
import '../cubit/decoration/decoration_state.dart';
import '../di/di.dart';
import '../views/swaying_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DecorationScreen extends StatelessWidget {
  final Function(int) updateIndex;

  const DecorationScreen({super.key, required this.updateIndex});

  @override
  DecorationScreenState createState() => DecorationScreenState();
}

class DecorationScreenState extends State<DecorationScreen> {
  late TextEditingController _petNameController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final PetNotifier notifier = Provider.of<PetNotifier>(context);
    _petNameController = TextEditingController(text: notifier.pet.name);
  }

  @override
  void dispose() {
    _petNameController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    final PetNotifier notifier = Provider.of<PetNotifier>(context);

    return BlocProvider(
      create: (_) {
        final cubit = DecorationCubit(
          getPetColorsUseCase: getIt(),
          setPetColorsUseCase: getIt(),
        );
        logger.info('DecorationCubit created');
        return cubit;
      },
      child: BlocListener<DecorationCubit, DecorationState>(
        listener: (context, state) {
          if (state is DecorationError) {
            logger.severe('DecorationError state received');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loc!.decoration_error),
              ),
            );
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _petNameController,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                decoration: const InputDecoration(
                  labelText: "Имя питомца",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (newName) async {
                  String trimmed = newName.trim();
                  if (trimmed.isNotEmpty) {
                    notifier.pet.name = trimmed;
                    await SharedPrefRepositoryImpl().setPet(notifier.pet);
                  }
                },
              ),
            ),
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: PetColors.values.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final petColorEnum = PetColors.values[index];
                    bool isSelected = (notifier.pet.color == petColorEnum);
                    return GestureDetector(
                      onTap: () async {
                        notifier.pet.color = petColorEnum;
                        await SharedPrefRepositoryImpl().setPet(notifier.pet);
                        await context.read<DecorationCubit>().updateColors(
                          mainColor: petColorEnum.main,
                          secondaryColor: petColorEnum.secondary,
                          tertiaryColor: petColorEnum.accent,
                        );
                        setState(() {});
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? Colors.black45
                                : Colors.transparent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                color: _hexToColor(petColorEnum.main),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: _hexToColor(petColorEnum.secondary),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: _hexToColor(petColorEnum.accent),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            BlocBuilder<DecorationCubit, DecorationState>(
              builder: (context, state) {
                if (state is DecorationInfo) {
                  return Center(
                    child: SizedBox(
                      height: 350,
                      width: 300,
                      child: SwayingSvg(
                        svgString: state.petString,
                        width: 200,
                        height: 200,
                      ),
                    ),
                  );
                } else if (state is DecorationLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  logger.info('DecorationScreen: unexpected state: $state');
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
