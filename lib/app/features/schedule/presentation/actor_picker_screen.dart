import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_gradient_bar.dart';
import '../../../shared/widgets/error_view.dart';
import '../data/schedule_providers.dart';
import '../domain/actor.dart';

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

  @override
  Widget build(BuildContext context) {
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
            preferredSize: Size.fromHeight(52),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  tabs: [
                    Tab(text: 'Группы'),
                    Tab(text: 'Преподаватели'),
                  ],
                ),
                AppGradientBar(),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onQueryChanged,
                decoration: InputDecoration(
                  hintText: 'Поиск',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchCtrl.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
                            _onQueryChanged('');
                          },
                        ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _ActorList(
                    asyncProvider: ref.watch(studentGroupsProvider),
                    filter: _filter,
                    onRetry: () => ref.invalidate(studentGroupsProvider),
                  ),
                  _ActorList(
                    asyncProvider: ref.watch(teachersProvider),
                    filter: _filter,
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
    required this.onRetry,
  });

  final AsyncValue<List<Actor>> asyncProvider;
  final List<Actor> Function(List<Actor>) filter;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return asyncProvider.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(error: e, onRetry: onRetry),
      data: (all) {
        final items = filter(all);
        if (items.isEmpty) {
          return const Center(child: Text('Ничего не найдено'));
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final a = items[i];
            return ListTile(
              title: Text(a.name),
              subtitle: Text('Кафедра №${a.departmentId}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/schedule/${a.id}'),
            );
          },
        );
      },
    );
  }
}