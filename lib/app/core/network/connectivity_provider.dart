import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Текущее состояние подключения к сети.
///
/// `null` = ещё проверяем (первый кадр). UI должен трактовать `null`
/// как онлайн, чтобы не мигать офлайн-баннером до первой проверки.
/// `true` = есть интернет, `false` = оффлайн.
class ConnectivityNotifier extends StateNotifier<bool?> {
  ConnectivityNotifier() : super(null) {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _sub;
  var _disposed = false;

  Future<void> _init() async {
    try {
      final initial = await _connectivity.checkConnectivity();
      await _updateFromResults(initial);
    } on Object catch (_) {
      if (!_disposed) state = true;
    }

    // Подписка на изменения интерфейса.
    _sub = _connectivity.onConnectivityChanged.listen((results) async {
      await _updateFromResults(results);
    });
  }

  Future<void> _updateFromResults(List<ConnectivityResult> results) async {
    if (_disposed) return;
    // Оффлайн только если ВСЕ результаты = none
    final hasInterface = results.any((r) => r != ConnectivityResult.none);
    if (!hasInterface) {
      state = false;
      return;
    }
    // Есть интерфейс — проверяем реальный интернет лёгким DNS-запросом,
    // чтобы captive-portal не считался онлайном.
    state = await _hasInternetAccess();
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup(
        'example.com',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on Object catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _sub?.cancel();
    super.dispose();
  }
}

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, bool?>((ref) {
      return ConnectivityNotifier();
    });

/// Удобный селектор: `true` пока статус неизвестен, чтобы первый кадр
/// не мигал офлайн-состоянием.
final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityProvider) ?? true;
});
