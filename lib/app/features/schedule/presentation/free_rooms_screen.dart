import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';
import 'package:ngieuapp/app/features/schedule/presentation/free_rooms/background_loader_notifier.dart';
import 'package:ngieuapp/app/features/schedule/presentation/free_rooms/filter_panel.dart';
import 'package:ngieuapp/app/features/schedule/presentation/free_rooms/loading_banner.dart';
import 'package:ngieuapp/app/features/schedule/presentation/free_rooms/room_card.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';
import 'package:ngieuapp/app/shared/widgets/app_gradient_bar.dart';
import 'package:ngieuapp/app/shared/widgets/empty_view.dart';
import 'package:ngieuapp/app/shared/widgets/error_view.dart';
import 'package:ngieuapp/app/shared/widgets/skeleton.dart';
import 'package:ngieuapp/app/theme/app_theme.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

export 'package:ngieuapp/app/features/schedule/presentation/free_rooms/background_loader_notifier.dart';

class FreeRoomsScreen extends ConsumerStatefulWidget {
  const FreeRoomsScreen({super.key});

  @override
  ConsumerState<FreeRoomsScreen> createState() => _FreeRoomsScreenState();
}

class _FreeRoomsScreenState extends ConsumerState<FreeRoomsScreen> {
  DateTime _date = DateTime.now();
  TimeOfDay _from = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _to = const TimeOfDay(hour: 12, minute: 0);
  bool _searched = false;
  int? _minDurationMinutes;
  String? _instituteFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(backgroundLoaderProvider.notifier).runIfNeeded();
    });
  }

  String _shortInstitute(String full) {
    if (full.contains('экономики')) return 'ИЭиУ';
    if (full.contains('информационных')) return 'ИИТиСС';
    if (full.contains('Инженерный')) return 'ИИ';
    return full;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      locale: const Locale('ru'),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isFrom ? _from : _to,
    );
    if (picked != null) {
      setState(() => isFrom ? _from = picked : _to = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;
    final dateFmt = DateFormat('EEEE, d MMMM', 'ru_RU');
    final loader = ref.watch(backgroundLoaderProvider);
    final minDurationMinutes =
        _minDurationMinutes ??
        ref.watch(appSettingsProvider).defaultFreeRoomDurationMinutes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Свободные аудитории'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(AppSizes.gradientBarHeight),
          child: AppGradientBar(),
        ),
      ),
      body: Column(
        children: [
          AnimatedSize(
            duration: AppDurations.normal,
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: kDebugMode && loader.isLoading
                ? LoadingBanner(loader: loader)
                : const SizedBox.shrink(),
          ),
          FreeRoomsFilterPanel(
            semantic: semantic,
            dateFmt: dateFmt,
            date: _date,
            from: _from,
            to: _to,
            minDurationMinutes: minDurationMinutes,
            instituteFilter: _instituteFilter,
            loader: loader,
            onPickDate: _pickDate,
            onPickTimeFrom: () => _pickTime(true),
            onPickTimeTo: () => _pickTime(false),
            onDurationPicked: (v) => setState(() => _minDurationMinutes = v),
            onInstitutePicked: (v) =>
                setState(() => _instituteFilter = v.isEmpty ? null : v),
            onSearch: () => setState(() => _searched = true),
            onLoadSchedule: () =>
                ref.read(backgroundLoaderProvider.notifier).run(),
            shortInstitute: _shortInstitute,
          ),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (!_searched) {
      return const EmptyView(
        text: 'Выберите параметры\nи нажмите «Найти»',
        icon: Icons.search,
      );
    }
    final loader = ref.watch(backgroundLoaderProvider);
    if (loader.isLoading) {
      return FreeRoomsLoadingView(loader: kDebugMode ? loader : null);
    }
    final minDurationMinutes =
        _minDurationMinutes ??
        ref.watch(appSettingsProvider).defaultFreeRoomDurationMinutes;
    final key = (
      date: _date,
      fromHour: _from.hour,
      fromMinute: _from.minute,
      toHour: _to.hour,
      toMinute: _to.minute,
      minDurationMinutes: minDurationMinutes,
      buildingFilter: '',
      instituteFilter: _instituteFilter ?? '',
    );
    final asyncValue = ref.watch(freeRoomsProvider(key));
    return asyncValue.when(
      loading: () => const ListSkeleton(),
      error: (e, _) => ErrorView(error: e),
      data: (rooms) {
        if (rooms.isEmpty) {
          return const EmptyView(
            text:
                'Свободных аудиторий не найдено.\n'
                'Попробуйте изменить параметры поиска.',
            icon: Icons.meeting_room_outlined,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            top: AppSpacing.md,
            bottom: 80,
          ),
          itemCount: rooms.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (_, i) => RoomCard(room: rooms[i]),
        );
      },
    );
  }
}

class FreeRoomsLoadingView extends StatelessWidget {
  const FreeRoomsLoadingView({super.key, this.loader});

  final BackgroundLoaderState? loader;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Загружаем расписание',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Проверяем занятость аудиторий\n'
              'и формируем список свободных',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: color),
            ),
            const SizedBox(height: AppSpacing.xl),
            ClipRRect(
              borderRadius: AppRadius.xsBr,
              child: LinearProgressIndicator(
                minHeight: 4,
                value: loader?.progress,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: theme.colorScheme.primary,
              ),
            ),
            if (loader != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${loader!.loaded}/${loader!.total}',
                style: theme.textTheme.labelSmall?.copyWith(color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
