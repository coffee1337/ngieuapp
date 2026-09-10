import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ngieuapp/app/core/network/connectivity_provider.dart';
import 'package:ngieuapp/app/features/campus/domain/campus_catalog.dart';
import 'package:ngieuapp/app/features/campus/presentation/widgets/campus_3d_map.dart';
import 'package:ngieuapp/app/features/schedule/domain/utils/floor_utils.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class CampusMapScreen extends ConsumerStatefulWidget {
  const CampusMapScreen({super.key, this.initialRoom});

  final String? initialRoom;

  @override
  ConsumerState<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends ConsumerState<CampusMapScreen> {
  late final TextEditingController _searchController;
  late String _query;

  @override
  void initState() {
    super.initState();
    _query = widget.initialRoom?.trim() ?? '';
    _searchController = TextEditingController(text: _query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setQuery(String value) => setState(() => _query = value.trim());

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(connectivityProvider);
    final room = CampusCatalog.resolveRoom(_query);
    final institutes = CampusCatalog.searchInstitutes(_query);
    final hasRoomQuery = RegExp(r'^\s*\d').hasMatch(_query);

    return Scaffold(
      appBar: AppBar(title: const Text('Карта кампуса')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxl,
          AppSpacing.md,
          AppSpacing.xxl,
          AppSpacing.section,
        ),
        children: [
          _CampusHeader(
            isOnline: isOnline,
            onDirections: isOnline
                ? () => context.push('/campus/directions')
                : null,
          ),
          const SizedBox(height: AppSpacing.xxl),
          const Campus3DMap(),
          const SizedBox(height: AppSpacing.xxl),
          TextField(
            controller: _searchController,
            onChanged: _setQuery,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              labelText: 'Найти кабинет или институт',
              hintText: 'Например, 220 или ИИТиСС',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Очистить',
                      onPressed: () {
                        _searchController.clear();
                        _setQuery('');
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          AnimatedSwitcher(
            duration: AppDurations.normal,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SizeTransition(sizeFactor: animation, child: child),
            ),
            child: hasRoomQuery
                ? _RoomResultCard(
                    key: ValueKey(_query),
                    result: room,
                    onDirections: isOnline
                        ? () => context.push('/campus/directions')
                        : null,
                  )
                : _InstituteResults(key: ValueKey(_query), items: institutes),
          ),
        ],
      ),
    );
  }
}

class _CampusHeader extends StatelessWidget {
  const _CampusHeader({required this.isOnline, required this.onDirections});

  final bool isOnline;
  final VoidCallback? onDirections;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primaryContainer, scheme.tertiaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.xxlBr,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_city_rounded, size: 36, color: scheme.primary),
          const SizedBox(height: AppSpacing.lg),
          Text('Главный кампус НГИЭУ', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            CampusCatalog.mainCampusAddress,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _LocationLine(
            icon: Icons.phone_outlined,
            text: CampusCatalog.phone,
          ),
          const _LocationLine(
            icon: Icons.alternate_email_rounded,
            text: CampusCatalog.email,
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.tonalIcon(
            onPressed: onDirections,
            icon: const Icon(Icons.directions_outlined),
            label: Text(
              isOnline ? 'Открыть маршрут' : 'Маршрут недоступен офлайн',
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomResultCard extends StatelessWidget {
  const _RoomResultCard({
    required this.result,
    required this.onDirections,
    super.key,
  });

  final CampusRoomResult result;
  final VoidCallback? onDirections;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    if (!result.isRecognized) {
      return _MessageCard(
        icon: Icons.search_off_rounded,
        title: 'Кабинет не распознан',
        text:
            'Введите трёхзначный номер, начинающийся с 1, 2 или 3. '
            'Нестандартные аудитории будут доступны после добавления планов.',
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: AppRadius.xlBr,
        border: Border.all(color: scheme.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                child: const Icon(Icons.meeting_room_outlined),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  'Аудитория ${result.query}',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _LocationLine(
            icon: Icons.account_balance_outlined,
            text: result.institute!.name,
          ),
          if (result.floor != null)
            _LocationLine(
              icon: Icons.stairs_outlined,
              text: FloorUtils.formatFloor(result.floor!),
            ),
          const _LocationLine(
            icon: Icons.location_on_outlined,
            text: CampusCatalog.mainCampusAddress,
          ),
          const _LocationLine(
            icon: Icons.offline_bolt_outlined,
            text: 'Информация доступна без интернета',
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onDirections,
              icon: const Icon(Icons.directions_outlined),
              label: Text(
                onDirections == null
                    ? 'Маршрут недоступен офлайн'
                    : 'Маршрут до корпуса',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstituteResults extends StatelessWidget {
  const _InstituteResults({required this.items, super.key});

  final List<CampusInstitute> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _MessageCard(
        icon: Icons.search_off_rounded,
        title: 'Ничего не найдено',
        text:
            'Попробуйте ввести номер кабинета или другое название '
            'института.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Институты', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.lg),
        for (final institute in items)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.apartment_rounded),
                title: Text(institute.name),
                subtitle: Text(
                  '${institute.shortName} · аудитории ${institute.roomPrefix}\n'
                  '${CampusCatalog.mainCampusAddress}',
                ),
                isThreeLine: false,
              ),
            ),
          ),
      ],
    );
  }
}

class _LocationLine extends StatelessWidget {
  const _LocationLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.icon,
    required this.title,
    required this.text,
    super.key,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.xlBr,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
