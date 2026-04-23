import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_gradient_bar.dart';
import '../../../shared/widgets/error_view.dart';
import '../../profile/data/profile_providers.dart';
import '../../profile/domain/student_identity.dart';
import '../data/schedule_providers.dart';
import '../domain/actor.dart';
import '../domain/department.dart';

class ActorPickerScreen extends ConsumerStatefulWidget {
  const ActorPickerScreen({super.key});

  @override
  ConsumerState<ActorPickerScreen> createState() => _ActorPickerScreenState();
}

class _ActorPickerScreenState extends ConsumerState<ActorPickerScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _query = q.trim().toLowerCase());
    });
  }

  List<Actor> _filter(List<Actor> all) {
    if (_query.isEmpty) return all;
    return all.where((a) => a.name.toLowerCase().contains(_query)).toList();
  }

  Future<void> _onActorTap(Actor a) async {
    if (a.type == ActorType.studentGroup) {
      final repo = ref.read(profileLocalDataSourceProvider);
      await repo.save(StudentIdentity(
        actorId: a.id,
        groupName: a.name,
        departmentId: a.departmentId,
      ));
      ref.invalidate(studentIdentityProvider);
    }
    if (mounted) {
      context.push('/schedule/${a.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Выберите расписание'),
          actions: [
            IconButton(
              tooltip: 'Свободные аудитории',
              icon: const Icon(Icons.meeting_room_outlined),
              onPressed: () => context.push('/schedule/free-rooms'),
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: TabBar(
              tabs: [
                Tab(text: 'Группы'),
                Tab(text: 'Преподаватели'),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            const AppGradientBar(),
            // Поисковая панель в своём блоке
            Container(
              color: theme.colorScheme.surface,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onQueryChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Название группы или ФИО',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchCtrl.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            _onQueryChanged('');
                          },
                        ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _ActorList(
                    asyncProvider: ref.watch(studentGroupsProvider),
                    filter: _filter,
                    onTap: _onActorTap,
                    onRetry: () => ref.invalidate(studentGroupsProvider),
                  ),
                  _ActorList(
                    asyncProvider: ref.watch(teachersProvider),
                    filter: _filter,
                    onTap: _onActorTap,
                    onRetry: () => ref.invalidate(teachersProvider),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActorList extends StatelessWidget {
  const _ActorList({
    required this.asyncProvider,
    required this.filter,
    required this.onTap,
    required this.onRetry,
  });

  final AsyncValue<List<Actor>> asyncProvider;
  final List<Actor> Function(List<Actor>) filter;
  final void Function(Actor) onTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return asyncProvider.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(error: e, onRetry: onRetry),
      data: (all) {
        final items = filter(all);
        if (items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Ничего не найдено',
                style: TextStyle(fontSize: 14),
              ),
            ),
          );
        }

        // Группируем по кафедре
        final grouped = <int, List<Actor>>{};
        for (final a in items) {
          grouped.putIfAbsent(a.departmentId, () => []).add(a);
        }
        final depIds = grouped.keys.toList()..sort();

        // CustomScrollView с SliverStickyHeader — sticky-заголовки
        return CustomScrollView(
          slivers: [
            for (final id in depIds)
              SliverMainAxisGroup(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _DepartmentHeaderDelegate(id: id),
                  ),
                  SliverList.separated(
                    itemCount: grouped[id]!.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      indent: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant
                          .withValues(alpha: 0.4),
                    ),
                    itemBuilder: (_, i) {
                      final a = grouped[id]![i];
                      return _ActorTile(actor: a, onTap: () => onTap(a));
                    },
                  ),
                ],
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        );
      },
    );
  }
}

class _DepartmentHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _DepartmentHeaderDelegate({required this.id});
  final int id;

  @override
  double get minExtent => 40;
  @override
  double get maxExtent => 40;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              Departments.nameOf(id),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _DepartmentHeaderDelegate old) => old.id != id;
}

class _ActorTile extends StatelessWidget {
  const _ActorTile({required this.actor, required this.onTap});
  final Actor actor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                actor.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}