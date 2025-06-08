import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytama/presentation/screens/main_scaffold.dart';
import 'package:moneytama/presentation/views/streak_info_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../tools/logger.dart';
import '../cubit/streak/streak_cubit.dart';
import '../cubit/streak/streak_state.dart';
import '../di/di.dart';
import '../navigation/navigation_service.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  static const String routeName = '/streak';

  @override
  Widget build(BuildContext context) {
    logger.info('StreakScreen build');
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) {
        final cubit = StreakCubit(getIt());
        logger.info('StreakInfoCubit created');
        return cubit;
      },
      child: BlocListener<StreakCubit, StreakState>(
        listener: (context, state) {
          if (state is StreakSkip) {
            logger.info(
                'StreakInfoSkip state received, navigating to MainScaffold');
            getIt<NavigationService>().navigateTo(MainScaffold.routeName);
          }
        },
        child: Scaffold(
          body: BlocBuilder<StreakCubit, StreakState>(
            builder: (context, state) {
              if (state is StreakLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 100,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.streak_title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.streak_info(state.currentStreak),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      StreakInfoView(attendance: state.attendance),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          getIt<NavigationService>().navigateTo(MainScaffold.routeName);
                        },
                        child: Text(l10n.streak_continue),
                      ),
                    ],
                  ),
                );
              } else if (state is StreakInitial) {
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