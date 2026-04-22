import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/error_view.dart';
import '../../../theme/app_colors.dart';
import '../data/profile_providers.dart';
import '../domain/student_identity.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = ref.watch(studentIdentityProvider);
    return identity.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: ErrorView(
          error: e,
          onRetry: () => ref.invalidate(studentIdentityProvider),
        ),
      ),
      data: (id) => id == null
          ? const _NotSetYet()
          : _ProfileContent(identity: id),
    );
  }
}

class _NotSetYet extends StatelessWidget {
  const _NotSetYet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
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
              'Откройте расписание, выберите свою группу,\nи она сохранится в профиле',
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

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              title: Text(
                identity.groupName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  shadows: [
                    Shadow(color: Colors.black54, blurRadius: 4),
                  ],
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient,
                ),
              ),
            ),
          ),
          SliverList.list(
            children: [
              const SizedBox(height: 8),
              _InfoTile(
                label: 'Группа',
                value: identity.groupName,
                icon: Icons.groups_outlined,
              ),
              _InfoTile(
                label: 'Курс',
                value: course == null ? '—' : '$course',
                icon: Icons.school_outlined,
              ),
              _InfoTile(
                label: 'Кафедра',
                value: '№${identity.departmentId}',
                icon: Icons.account_balance_outlined,
              ),
              if (identity.fullName != null)
                _InfoTile(
                  label: 'ФИО',
                  value: identity.fullName!,
                  icon: Icons.badge_outlined,
                ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('Моё расписание'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/schedule/${identity.actorId}'),
              ),
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text('Оценки'),
                subtitle: const Text('Появятся в ближайших обновлениях'),
                enabled: false,
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Сменить группу',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                onTap: () async {
                  await ref.read(profileLocalDataSourceProvider).clear();
                  ref.invalidate(studentIdentityProvider);
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
      title: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        value,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}