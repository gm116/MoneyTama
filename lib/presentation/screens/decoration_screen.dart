import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneytama/presentation/cubit/decoration/decoration_cubit.dart';

import '../../tools/logger.dart';
import '../cubit/decoration/decoration_state.dart';
import '../di/di.dart';

class DecorationScreen extends StatelessWidget {
  final Function(int) updateIndex;

  const DecorationScreen({super.key, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
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
              const SnackBar(
                content: Text('Error loading decoration. Please try again.'),
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
                      child: SvgPicture.string(
                        state.petString,
                        height: 200,
                        width: 200,
                      ),
                    )
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
