import 'dart:async';

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
    if (state.isLoading) return _completer?.future;
    _completer = Completer<void>();

    final groups = await _ref.read(studentGroupsProvider.future);
    state = BackgroundLoaderState(
      isLoading: true,
      loaded: 0,
      total: groups.length,
      lastRunTime: state.lastRunTime,
      shouldAutoLoad: state.shouldAutoLoad,
    );

    final apiDs = _ref.read(scheduleApiDataSourceProvider);
    final dbDs = _ref.read(scheduleDbDataSourceProvider);
    _ref.invalidate(freeRoomsProvider);

    const batchSize = 3;
    var loadedCount = 0;

    await Future.doWhile(() async {
      if (loadedCount >= groups.length) return false;
      final batch = groups.skip(loadedCount).take(batchSize).toList();
      try {
        await Future.wait(
          batch.map((g) async {
            try {
              final lessons = await apiDs
                  .fetchSchedule(g.id)
                  .timeout(const Duration(seconds: 10));
              await dbDs.replaceForActor(g.id, lessons);
            } catch (_) {}
            loadedCount++;
            state = BackgroundLoaderState(
              isLoading: true,
              loaded: loadedCount,
              total: groups.length,
              lastRunTime: state.lastRunTime,
              shouldAutoLoad: state.shouldAutoLoad,
            );
          }),
        );
      } catch (_) {
        loadedCount += batch.length;
      }
      await Future.delayed(const Duration(milliseconds: 50));
      return true;
    });

    state = BackgroundLoaderState(
      isLoading: false,
      loaded: loadedCount,
      total: groups.length,
      lastRunTime: DateTime.now(),
      shouldAutoLoad: state.shouldAutoLoad,
    );
    _ref.invalidate(freeRoomsProvider);
    _completer?.complete();
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
