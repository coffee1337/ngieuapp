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
    final lower = full.toLowerCase();
    if (lower.contains('экономик')) return 'ИЭиУ';
    if (lower.contains('информационн')) return 'ИИТиСС';
    if (lower.contains('инженерн')) return 'ИИ';
    return full;
  }

  void _changeFilter(VoidCallback change) {
    setState(() {
      change();
      _searched = false;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      locale: const Locale('ru'),
    );
    if (picked != null) _changeFilter(() => _date = picked);
  }

  Future<void> _pickTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isFrom ? _from : _to,
    );
    if (picked != null) {
      _changeFilter(() => isFrom ? _from = picked : _to = picked);
    }
  }

  void _runSearch() {
    final fromMinutes = _from.hour * 60 + _from.minute;
    final toMinutes = _to.hour * 60 + _to.minute;
    if (toMinutes <= fromMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Время «До» должно быть позже времени «С»'),
        ),
      );
      return;
    }
    ref.invalidate(freeRoomsProvider);
    setState(() => _searched = true);
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AnimatedSize(
              duration: AppDurations.normal,
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: loader.isLoading
                  ? LoadingBanner(loader: loader)
                  : const SizedBox.shrink(),
            ),
          ),
          SliverToBoxAdapter(
            child: FreeRoomsFilterPanel(
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
              onDurationPicked: (value) =>
                  _changeFilter(() => _minDurationMinutes = value),
              onInstitutePicked: (value) => _changeFilter(
                () => _instituteFilter = value.isEmpty ? null : value,
              ),
              onSearch: _runSearch,
              onLoadSchedule: () =>
                  ref.read(backgroundLoaderProvider.notifier).run(),
              shortInstitute: _shortInstitute,
            ),
          ),
          ..._buildResultSlivers(),
        ],
      ),
    );
  }

  List<Widget> _buildResultSlivers() {
    if (!_searched) {
      return const [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 220,
            child: EmptyView(
              text: 'Выберите параметры\nи нажмите «Найти»',
              icon: Icons.search_rounded,
            ),
          ),
        ),
      ];
    }
    final loader = ref.watch(backgroundLoaderProvider);
    if (loader.isLoading) {
      return [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
            child: FreeRoomsLoadingView(loader: loader),
          ),
        ),
      ];
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
    return asyncValue.when<List<Widget>>(
      loading: () => const [
        SliverToBoxAdapter(
          child: SizedBox(height: 280, child: FreeRoomsLoadingView()),
        ),
      ],
      error: (e, _) => [
        SliverToBoxAdapter(
          child: SizedBox(height: 240, child: ErrorView(error: e)),
        ),
      ],
      data: (rooms) {
        if (rooms.isEmpty) {
          return const [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 240,
                child: EmptyView(
                  text:
                      'Свободных аудиторий не найдено.\n'
                      'Попробуйте изменить параметры поиска.',
                  icon: Icons.meeting_room_outlined,
                ),
              ),
            ),
          ];
        }
        return [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.md,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Свободные аудитории',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: AppRadius.pillBr,
                    ),
                    child: Text(
                      '${rooms.length}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              0,
              AppSpacing.xl,
              80,
            ),
            sliver: SliverList.separated(
              itemCount: rooms.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, index) => RoomCard(room: rooms[index]),
            ),
          ),
        ];
      },
    );
  }
}

class FreeRoomsLoadingView extends StatefulWidget {
  const FreeRoomsLoadingView({super.key, this.loader});

  final BackgroundLoaderState? loader;

  @override
  State<FreeRoomsLoadingView> createState() => _FreeRoomsLoadingViewState();
}

class _FreeRoomsLoadingViewState extends State<FreeRoomsLoadingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxxl,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Transform.scale(
                scale: 0.92 + _controller.value * 0.12,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.55 + _controller.value * 0.35,
                    ),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(
                        alpha: 0.25 + _controller.value * 0.35,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.meeting_room_rounded,
                    size: 32,
                    color: theme.colorScheme.primary,
                  ),
                ),
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
                value: widget.loader?.progress,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: theme.colorScheme.primary,
              ),
            ),
            if (widget.loader != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${widget.loader!.loaded}/${widget.loader!.total}',
                style: theme.textTheme.labelSmall?.copyWith(color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
