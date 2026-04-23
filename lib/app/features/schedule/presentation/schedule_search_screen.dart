import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/app_gradient_bar.dart';
import '../../../shared/widgets/empty_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../data/schedule_providers.dart';
import '../domain/lesson.dart';
import '../domain/usecases/search_schedule.dart';

class ScheduleSearchScreen extends ConsumerStatefulWidget {
  const ScheduleSearchScreen({super.key});

  @override
  ConsumerState<ScheduleSearchScreen> createState() =>
      _ScheduleSearchScreenState();
}

class _ScheduleSearchScreenState extends ConsumerState<ScheduleSearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _ctrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _query = v.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          onChanged: _onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Предмет, препод, ауд., группа',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          style: theme.textTheme.titleMedium,
        ),
        actions: [
          if (_ctrl.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _ctrl.clear();
                _onChanged('');
              },
            ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: AppGradientBar(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_query.length < 2) {
      return const EmptyView(
        text: 'Введите минимум 2 символа',
        icon: Icons.search,
      );
    }
    final asyncValue = ref.watch(scheduleSearchResultsProvider(_query));
    return asyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(error: e),
      data: (results) {
        if (results.isEmpty) {
          return const EmptyView(
            text: 'Ничего не найдено.\n'
                'Возможно, нужно загрузить расписание\n'
                'всех групп в «Свободные аудитории».',
            icon: Icons.search_off,
          );
        }
        return _buildGrouped(results);
      },
    );
  }

  Widget _buildGrouped(List<SearchScheduleResult> results) {
    // Группируем по дате для заголовков
    final byDate = <DateTime, List<SearchScheduleResult>>{};
    for (final r in results) {
      byDate.putIfAbsent(r.lesson.date, () => []).add(r);
    }
    final dates = byDate.keys.toList()..sort();
    final dayFmt = DateFormat('EEEE, d MMMM', 'ru_RU');

    final flat = <Object>[];
    for (final d in dates) {
      flat.add(d);
      flat.addAll(byDate[d]!);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: flat.length,
      itemBuilder: (_, i) {
        final item = flat[i];
        if (item is DateTime) {
          return _DateHeader(date: item, formatter: dayFmt);
        }
        final r = item as SearchScheduleResult;
        return _SearchResultTile(result: r, query: _query);
      },
    );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date, required this.formatter});
  final DateTime date;
  final DateFormat formatter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = _isSameDay(date, DateTime.now());
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            isToday ? 'Сегодня' : formatter.format(date),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (!isToday) ...[
            const SizedBox(width: 8),
            Text(
              formatter.format(date).split(',').first,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.result, required this.query});
  final SearchScheduleResult result;
  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = DateFormat('HH:mm');
    final l = result.lesson;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _iconFor(result.matchType),
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                _labelFor(result.matchType),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${fmt.format(l.startTime)} — ${fmt.format(l.endTime)}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _Highlighted(
            text: l.subject,
            query: query,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (l.teacherNames.isNotEmpty) ...[
            const SizedBox(height: 2),
            _Highlighted(
              text: l.teacherNames.join(', '),
              query: query,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Row(
            children: [
              if (l.classroom.isNotEmpty) ...[
                Icon(
                  Icons.place_outlined,
                  size: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 3),
                _Highlighted(
                  text: 'Ауд. ${l.classroom}',
                  query: query,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              if (l.groupNames.isNotEmpty)
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.groups_outlined,
                        size: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: _Highlighted(
                          text: l.groupNames.join(', '),
                          query: query,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _iconFor(SearchMatchType t) => switch (t) {
        SearchMatchType.subject => Icons.book_outlined,
        SearchMatchType.teacher => Icons.person_outline,
        SearchMatchType.classroom => Icons.meeting_room_outlined,
        SearchMatchType.group => Icons.groups_outlined,
      };

  String _labelFor(SearchMatchType t) => switch (t) {
        SearchMatchType.subject => 'Предмет',
        SearchMatchType.teacher => 'Преподаватель',
        SearchMatchType.classroom => 'Аудитория',
        SearchMatchType.group => 'Группа',
      };
}

/// Подсветка совпадений поискового запроса в тексте.
class _Highlighted extends StatelessWidget {
  const _Highlighted({
    required this.text,
    required this.query,
    this.style,
    this.maxLines,
  });
  final String text;
  final String query;
  final TextStyle? style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: style, maxLines: maxLines,
          overflow: maxLines != null ? TextOverflow.ellipsis : null);
    }
    final theme = Theme.of(context);
    final lower = text.toLowerCase();
    final q = query.toLowerCase();
    final spans = <TextSpan>[];

    var i = 0;
    while (i < text.length) {
      final idx = lower.indexOf(q, i);
      if (idx < 0) {
        spans.add(TextSpan(text: text.substring(i)));
        break;
      }
      if (idx > i) {
        spans.add(TextSpan(text: text.substring(i, idx)));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + q.length),
        style: (style ?? const TextStyle()).copyWith(
          backgroundColor: theme.colorScheme.primaryContainer,
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ));
      i = idx + q.length;
    }

    return Text.rich(
      TextSpan(children: spans, style: style),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}