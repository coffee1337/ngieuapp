import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/features/schedule/data/favorite_actors_providers.dart';
import 'package:ngieuapp/app/features/schedule/presentation/actor_picker_screen.dart';
import 'package:ngieuapp/app/features/schedule/presentation/week_schedule_screen.dart';
import 'package:ngieuapp/app/shared/widgets/error_view.dart';
import 'package:ngieuapp/app/shared/widgets/skeleton.dart';

class ScheduleHomeScreen extends ConsumerWidget {
  const ScheduleHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeActorId = ref.watch(activeFavoriteActorIdProvider);

    return activeActorId.when(
      loading: () => const Scaffold(body: ScheduleSkeleton()),
      error: (error, _) => Scaffold(
        body: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(activeFavoriteActorIdProvider),
        ),
      ),
      data: (actorId) {
        if (actorId == null || actorId.isEmpty) {
          return const ActorPickerScreen();
        }
        return WeekScheduleScreen(actorId: actorId);
      },
    );
  }
}
