import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/error_view.dart';
import '../../../theme/app_colors.dart';
import '../../schedule/data/schedule_providers.dart';
import '../../schedule/domain/department.dart';
import '../../schedule/domain/lesson.dart';
import '../../widget/home_widget_service.dart';
import '../data/profile_providers.dart';
import '../domain/student_identity.dart';

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
        loading: () => const Center(child: CircularProgressIndicator()),
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Вы ещё не выбрали группу',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Откройте расписание, выберите свою группу,\nи она появится в профиле',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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

    // Обновляем виджет, когда есть свежие данные расписания.
    ref.listen(weekScheduleProvider(key), (_, next) {
      next.whenData((lessons) {
        HomeWidgetService.instance.updateNextLesson(lessons);
      });
    });

    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
          decoration: const BoxDecoration(gradient: AppColors.brandGradient),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                identity.groupName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                Departments.nameOf(identity.departmentId),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _StatCard(
                    label: 'Курс',
                    value: course == null ? '—' : '$course',
                  ),
                  const SizedBox(width: 8),
                  lessonsAsync.when(
                    loading: () => const _StatCard(label: 'Сегодня', value: '…'),
                    error: (_, __) => const _StatCard(label: 'Сегодня', value: '—'),
                    data: (lessons) {
                      final todayCount = lessons
                          .where((l) =>
                              l.date.year == today.year &&
                              l.date.month == today.month &&
                              l.date.day == today.day)
                          .length;
                      return _StatCard(
                        label: 'Сегодня пар',
                        value: '$todayCount',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        lessonsAsync.maybeWhen(
          data: (lessons) {
            final now = DateTime.now();
            final next = lessons
                .where((l) => l.endTime.isAfter(now))
                .toList()
              ..sort((a, b) => a.startTime.compareTo(b.startTime));
            if (next.isEmpty) return const SizedBox.shrink();
            final l = next.first;
            return Padding(
              padding: const EdgeInsets.all(12),
              child: _NextLessonCard(lesson: l),
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.schedule),
          title: const Text('Моё расписание'),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => context.push('/schedule/${identity.actorId}'),
        ),
        ListTile(
          leading: const Icon(Icons.meeting_room_outlined),
          title: const Text('Свободные аудитории'),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => context.push('/schedule/free-rooms'),
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Настройки'),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => context.push('/profile/settings'),
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.logout, color: theme.colorScheme.error),
          title: Text('Сменить группу',
              style: TextStyle(color: theme.colorScheme.error)),
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

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextLessonCard extends StatelessWidget {
  const _NextLessonCard({required this.lesson});
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = DateFormat('HH:mm');
    final now = DateTime.now();
    final isNow = now.isAfter(lesson.startTime) && now.isBefore(lesson.endTime);
    final minsUntilStart = lesson.startTime.difference(now).inMinutes;

    String statusText;
    if (isNow) {
      statusText = 'Идёт сейчас';
    } else if (minsUntilStart < 60) {
      statusText = 'Через $minsUntilStart мин';
    } else if (minsUntilStart < 60 * 24) {
      final h = minsUntilStart ~/ 60;
      statusText = 'Через $h ч';
    } else {
      statusText = DateFormat('EEE, HH:mm', 'ru_RU').format(lesson.startTime);
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isNow ? Icons.play_circle : Icons.upcoming,
                size: 18,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 6),
              Text(
                isNow ? 'СЕЙЧАС' : 'СЛЕДУЮЩАЯ ПАРА',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                statusText,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            lesson.subject,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time,
                  size: 14,
                  color: theme.colorScheme.onPrimaryContainer
                      .withValues(alpha: 0.8)),
              const SizedBox(width: 4),
              Text(
                '${fmt.format(lesson.startTime)}—${fmt.format(lesson.endTime)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              if (lesson.classroom.isNotEmpty) ...[
                Icon(Icons.place,
                    size: 14,
                    color: theme.colorScheme.onPrimaryContainer
                        .withValues(alpha: 0.8)),
                const SizedBox(width: 4),
                Text(
                  'Ауд. ${lesson.classroom}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}