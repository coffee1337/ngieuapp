import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Текущее состояние подключения к сети.
/// true = есть интернет, false = оффлайн.
class ConnectivityNotifier extends StateNotifier<bool> {
  ConnectivityNotifier() : super(true) {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _sub;

  Future<void> _init() async {
    // Первоначальная проверка
    final initial = await _connectivity.checkConnectivity();
    state = _isOnline(initial);

    // Подписка на изменения
    _sub = _connectivity.onConnectivityChanged.listen((results) {
      state = _isOnline(results);
    });
  }

  bool _isOnline(List<ConnectivityResult> results) {
    // Оффлайн только если ВСЕ результаты = none
    return results.any((r) => r != ConnectivityResult.none);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, bool>((
  ref,
) {
  return ConnectivityNotifier();
});
