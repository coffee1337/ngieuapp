import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngieuapp/app/features/profile/data/profile_providers.dart';
import 'package:ngieuapp/app/features/profile/domain/student_identity.dart';
import 'package:ngieuapp/app/features/profile/presentation/widgets/next_lesson_card.dart';
import 'package:ngieuapp/app/features/profile/presentation/widgets/profile_header.dart';
import 'package:ngieuapp/app/features/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:ngieuapp/app/features/schedule/data/favorite_actors_providers.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';
import 'package:ngieuapp/app/features/schedule/domain/favorite_actor.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';
import 'package:ngieuapp/app/features/widget/home_widget_provider.dart';
import 'package:ngieuapp/app/shared/widgets/error_view.dart';
import 'package:ngieuapp/app/shared/widgets/skeleton.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = ref.watch(studentIdentityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            tooltip: 'Настройки',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/profile/settings'),
          ),
        ],
      ),
      body: identity.when(
        loading: () => const ListSkeleton(itemCount: 3),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(studentIdentityProvider),
        ),
        data: (id) =>
            id == null ? const _NotSetYet() : _ProfileContent(identity: id),
      ),
    );
  }
}

class _NotSetYet extends StatelessWidget {
  const _NotSetYet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: 48,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Вы ещё не выбрали группу',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Откройте расписание, выберите свою группу\n'
                        'и она появится в профиле',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => context.go('/schedule'),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Выбрать группу'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({required this.identity});
  final StudentIdentity identity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = identity.computedCourse;
    final theme = Theme.of(context);
    final isStudentGroup = identity.isStudentGroup;

    final today = DateTime.now();
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final key = (
      actorId: identity.actorId,
      weekStart: DateTime(weekStart.year, weekStart.month, weekStart.day),
    );
    final lessonsAsync = ref.watch(weekScheduleProvider(key));
    final settings = ref.watch(appSettingsProvider);

    ref.listen(weekScheduleProvider(key), (_, next) {
      next.whenData(
        (lessons) => ref
            .read(homeWidgetServiceProvider)
            .updateNextLesson(
              lessons,
              enabled: settings.homeWidgetEnabled,
              showRoom: settings.homeWidgetShowRoom,
            ),
      );
    });

    return ListView(
      children: [
        ProfileHeader(
          identity: identity,
          courseStats: isStudentGroup
              ? StatCard(label: 'Курс', value: course == null ? '—' : '$course')
              : const StatCard(label: 'Тип', value: 'Преподаватель'),
          todayStats: lessonsAsync.when(
            loading: () => const StatCard(label: 'Сегодня', value: '…'),
            error: (_, __) => const StatCard(label: 'Сегодня', value: '—'),
            data: (lessons) {
              final todayCount = lessons
                  .where(
                    (l) =>
                        l.date.year == today.year &&
                        l.date.month == today.month &&
                        l.date.day == today.day,
                  )
                  .length;
              return StatCard(label: 'Сегодня пар', value: '$todayCount');
            },
          ),
        ),
        lessonsAsync.maybeWhen(
          data: (lessons) {
            final getNext = ref.watch(getNextLessonProvider);
            final l = getNext(lessons);
            if (l == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
              child: NextLessonCard(lesson: l),
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        _FavoriteSchedulesSection(currentIdentity: identity),
        const Divider(height: 1),
        ProfileMenuTile(
          icon: Icons.schedule,
          title: 'Моё расписание',
          onTap: () async {
            await ref
                .read(favoriteActorsLocalDataSourceProvider)
                .addFavoriteActor(
                  FavoriteActor(
                    id: identity.actorId,
                    name: identity.displayName,
                    type: identity.actorType,
                    departmentId: identity.departmentId ?? 0,
                    departmentName: identity.departmentName,
                  ),
                );
            await ref
                .read(favoriteActorsLocalDataSourceProvider)
                .setActiveActor(identity.actorId);
            ref
              ..invalidate(favoriteActorsProvider)
              ..invalidate(activeFavoriteActorIdProvider);
            if (context.mounted) {
              await context.push('/schedule/${identity.actorId}');
            }
          },
        ),
        ProfileMenuTile(
          icon: Icons.meeting_room_outlined,
          title: 'Свободные аудитории',
          onTap: () => context.push('/schedule/free-rooms'),
        ),
        ProfileMenuTile(
          icon: Icons.search,
          title: 'Поиск по расписанию',
          onTap: () => context.push('/schedule/search'),
        ),
        ProfileMenuTile(
          icon: Icons.settings_outlined,
          title: 'Настройки',
          onTap: () => context.push('/profile/settings'),
        ),
        const Divider(height: 1),
        ProfileMenuTile(
          icon: Icons.logout,
          title: 'Сменить группу',
          iconColor: theme.colorScheme.error,
          textColor: theme.colorScheme.error,
          onTap: () async {
            await ref.read(profileLocalDataSourceProvider).clear();
            ref.invalidate(studentIdentityProvider);
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _FavoriteSchedulesSection extends ConsumerWidget {
  const _FavoriteSchedulesSection({required this.currentIdentity});

  final StudentIdentity currentIdentity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteActorsProvider);
    return favoritesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (favorites) {
        if (favorites.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Избранные расписания',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            for (final actor in favorites)
              ProfileMenuTile(
                icon:
                    actor.type == currentIdentity.actorType &&
                        actor.id == currentIdentity.actorId
                    ? Icons.school_outlined
                    : Icons.star_outline,
                title: actor.name,
                subtitle: actor.departmentName.isEmpty
                    ? null
                    : actor.departmentName,
                onTap: () => _openFavorite(context, ref, actor),
              ),
          ],
        );
      },
    );
  }

  Future<void> _openFavorite(
    BuildContext context,
    WidgetRef ref,
    FavoriteActor actor,
  ) async {
    await ref
        .read(favoriteActorsLocalDataSourceProvider)
        .setActiveActor(actor.id);
    ref.invalidate(activeFavoriteActorIdProvider);
    if (context.mounted) {
      await context.push('/schedule/${actor.id}', extra: actor);
    }
  }
}
