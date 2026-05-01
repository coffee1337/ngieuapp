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
    final isDark = theme.brightness == Brightness.dark;

    final today = DateTime.now();
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final key = (
      actorId: identity.actorId,
      weekStart: DateTime(weekStart.year, weekStart.month, weekStart.day),
    );
    final lessonsAsync = ref.watch(weekScheduleProvider(key));

    // Update home widget
    ref.listen(weekScheduleProvider(key), (_, next) {
      next.whenData((lessons) {
        HomeWidgetService.instance.updateNextLesson(lessons);
      });
    });

    return ListView(
      children: [
        // Gradient header with profile info
        Container(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          identity.groupName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Departments.nameOf(identity.departmentId),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                    loading: () =>
                        const _StatCard(label: 'Сегодня', value: '…'),
                    error: (_, __) =>
                        const _StatCard(label: 'Сегодня', value: '—'),
                    data: (lessons) {
                      final todayCount = lessons
                          .where(
                            (l) =>
                                l.date.year == today.year &&
                                l.date.month == today.month &&
                                l.date.day == today.day,
                          )
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

        // Next lesson card
        lessonsAsync.maybeWhen(
          data: (lessons) {
            final now = DateTime.now();
            final next = lessons.where((l) => l.endTime.isAfter(now)).toList()
              ..sort((a, b) => a.startTime.compareTo(b.startTime));
            if (next.isEmpty) return const SizedBox.shrink();
            final l = next.first;
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
              child: _NextLessonCard(lesson: l),
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),

        const SizedBox(height: 8),
        const Divider(height: 1),

        // Menu items
        _MenuTile(
          icon: Icons.schedule,
          title: 'Моё расписание',
          onTap: () => context.push('/schedule/${identity.actorId}'),
        ),
        _MenuTile(
          icon: Icons.meeting_room_outlined,
          title: 'Свободные аудитории',
          onTap: () => context.push('/schedule/free-rooms'),
        ),
        _MenuTile(
          icon: Icons.search,
          title: 'Поиск по расписанию',
          onTap: () => context.push('/schedule/search'),
        ),
        _MenuTile(
          icon: Icons.settings_outlined,
          title: 'Настройки',
          onTap: () => context.push('/profile/settings'),
        ),

        const Divider(height: 1),

        _MenuTile(
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

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                fontSize: 22,
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
    final isDark = theme.brightness == Brightness.dark;
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

    final containerColor = isNow
        ? theme.colorScheme.primaryContainer
        : (isDark
              ? theme.colorScheme.surfaceContainerHigh
              : theme.colorScheme.primaryContainer);

    final onContainerColor = isNow
        ? theme.colorScheme.onPrimaryContainer
        : (isDark
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onPrimaryContainer);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
        border: isDark && !isNow
            ? Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                width: 1,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isNow ? Icons.play_circle_fill : Icons.upcoming,
                size: 18,
                color: onContainerColor,
              ),
              const SizedBox(width: 6),
              Text(
                isNow ? 'СЕЙЧАС' : 'СЛЕДУЮЩАЯ ПАРА',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: onContainerColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isNow
                      ? theme.colorScheme.primary.withValues(alpha: 0.15)
                      : theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isNow
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            lesson.subject,
            style: theme.textTheme.titleMedium?.copyWith(
              color: onContainerColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: onContainerColor.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
              Text(
                '${fmt.format(lesson.startTime)}—${fmt.format(lesson.endTime)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: onContainerColor,
                ),
              ),
              const SizedBox(width: 12),
              if (lesson.classroom.isNotEmpty) ...[
                Icon(
                  Icons.place,
                  size: 14,
                  color: onContainerColor.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  'Ауд. ${lesson.classroom}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: onContainerColor,
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

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: iconColor ?? theme.colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 20,
        color: textColor ?? theme.colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
