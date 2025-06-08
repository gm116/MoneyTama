import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneytama/presentation/cubit/decoration/decoration_cubit.dart';

import '../../tools/logger.dart';
import '../cubit/decoration/decoration_state.dart';
import '../di/di.dart';
import '../views/swaying_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DecorationScreen extends StatelessWidget {
  final Function(int) updateIndex;

  const DecorationScreen({super.key, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) {
        final cubit = DecorationCubit(
          getPetColorsUseCase: getIt(), setPetColorsUseCase: getIt(),
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
        child: Scaffold(
          body: BlocBuilder<DecorationCubit, DecorationState>(
            builder: (context, state) {
              if (state is DecorationInfo) {
                return Center(
                    child: SizedBox(
                      height: 300,
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
                logger.info('streakInfoScreen: unexpected state: $state');
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}