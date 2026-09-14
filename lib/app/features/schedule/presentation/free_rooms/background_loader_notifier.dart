import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';

class BackgroundLoaderState {
  const BackgroundLoaderState({
    required this.isLoading,
    required this.loaded,
    required this.total,
    required this.lastRunTime,
    required this.shouldAutoLoad,
  });
  final bool isLoading;
  final int loaded;
  final int total;
  final DateTime? lastRunTime;
  final bool shouldAutoLoad;

  double? get progress => total == 0 ? null : loaded / total;

  bool get shouldRunAutomatically {
    if (!shouldAutoLoad) return false;
    if (isLoading) return false;
    if (lastRunTime == null) return true;
    final now = DateTime.now();
    final elapsed = now.difference(lastRunTime!);
    if (loaded < total * 0.5) return true;
    if (elapsed > const Duration(hours: 2)) return true;
    if (elapsed > const Duration(minutes: 30) && loaded < total) return true;
    return false;
  }
}

class BackgroundLoaderNotifier extends StateNotifier<BackgroundLoaderState> {
  BackgroundLoaderNotifier(this._ref)
    : super(
        const BackgroundLoaderState(
          isLoading: false,
          loaded: 0,
          total: 0,
          lastRunTime: null,
          shouldAutoLoad: true,
        ),
      );

  final Ref _ref;
  Completer<void>? _completer;

  Future<void> run() async {
    final existing = _completer;
    if (existing != null) return existing.future;
    final completer = Completer<void>();
    _completer = completer;
    // Set loading before the first await so concurrent callers share one run.
    state = BackgroundLoaderState(
      isLoading: true,
      loaded: 0,
      total: 0,
      lastRunTime: state.lastRunTime,
      shouldAutoLoad: state.shouldAutoLoad,
    );
    unawaited(_runBatch(completer));
    return completer.future;
  }

  Future<void> _runBatch(Completer<void> completer) async {
    final apiDs = _ref.read(scheduleApiDataSourceProvider);
    final dbDs = _ref.read(scheduleDbDataSourceProvider);
    const batchSize = 3;
    var loadedCount = 0;
    var total = 0;
    try {
      final groups = await _ref.read(studentGroupsProvider.future);
      if (!mounted) return;
      total = groups.length;
      final anchorDate = (await _ref.read(currentWeekTypeProvider.future)).date;
      if (!mounted) return;
      for (var offset = 0; offset < groups.length; offset += batchSize) {
        if (!mounted) return;
        final batch = groups.skip(offset).take(batchSize);
        await Future.wait(
          batch.map((g) async {
            final cancellation = CancelToken();
            try {
              final lessons = await apiDs
                  .fetchSchedule(g.id, anchorDate: anchorDate, ct: cancellation)
                  .timeout(
                    const Duration(seconds: 10),
                    onTimeout: () {
                      cancellation.cancel('Background schedule timeout');
                      throw TimeoutException('Schedule ${g.id}');
                    },
                  );
              if (!mounted) return;
              await dbDs.replaceForActor(g.id, lessons);
              loadedCount++;
            } on Object catch (error) {
              if (kDebugMode) debugPrint('Schedule ${g.id} failed: $error');
            }
            if (!mounted) return;
            state = BackgroundLoaderState(
              isLoading: true,
              loaded: loadedCount,
              total: total,
              lastRunTime: state.lastRunTime,
              shouldAutoLoad: state.shouldAutoLoad,
            );
          }),
        );
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    } on Object catch (error) {
      if (kDebugMode) debugPrint('Background schedule load failed: $error');
    } finally {
      if (mounted) {
        state = BackgroundLoaderState(
          isLoading: false,
          loaded: loadedCount,
          total: total,
          lastRunTime: DateTime.now(),
          shouldAutoLoad: state.shouldAutoLoad,
        );
        _ref.invalidate(freeRoomsProvider);
      }
      _completer = null;
      completer.complete();
    }
  }

  Future<void> runIfNeeded() async {
    if (state.shouldRunAutomatically) await run();
  }

  void setAutoLoad(bool enabled) {
    state = BackgroundLoaderState(
      isLoading: state.isLoading,
      loaded: state.loaded,
      total: state.total,
      lastRunTime: state.lastRunTime,
      shouldAutoLoad: enabled,
    );
  }

  void resetLastRunTime() {
    state = BackgroundLoaderState(
      isLoading: state.isLoading,
      loaded: state.loaded,
      total: state.total,
      lastRunTime: null,
      shouldAutoLoad: state.shouldAutoLoad,
    );
  }
}

final backgroundLoaderProvider =
    StateNotifierProvider<BackgroundLoaderNotifier, BackgroundLoaderState>(
      BackgroundLoaderNotifier.new,
    );
