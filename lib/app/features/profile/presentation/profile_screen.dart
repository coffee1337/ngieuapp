import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngieuapp/app/features/profile/data/profile_providers.dart';
import 'package:ngieuapp/app/features/profile/domain/student_identity.dart';
import 'package:ngieuapp/app/features/profile/presentation/widgets/next_lesson_card.dart';
import 'package:ngieuapp/app/features/profile/presentation/widgets/profile_header.dart';
import 'package:ngieuapp/app/features/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            'Откройте расписание, выберите свою группу,\nи она появится в профиле',
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

    final today = DateTime.now();
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final key = (
      actorId: identity.actorId,
      weekStart: DateTime(weekStart.year, weekStart.month, weekStart.day),
    );
    final lessonsAsync = ref.watch(weekScheduleProvider(key));

    ref.listen(weekScheduleProvider(key), (_, next) {
      next.whenData(ref.read(homeWidgetServiceProvider).updateNextLesson);
    });

    return ListView(
      children: [
        ProfileHeader(
          identity: identity,
          courseStats: StatCard(
            label: 'Курс',
            value: course == null ? '—' : '$course',
          ),
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
              return StatCard(
                label: 'Сегодня пар',
                value: '$todayCount',
              );
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
        ProfileMenuTile(
          icon: Icons.schedule,
          title: 'Моё расписание',
          onTap: () => context.push('/schedule/${identity.actorId}'),
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
