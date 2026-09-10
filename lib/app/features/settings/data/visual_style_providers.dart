import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ngieuapp/app/theme/app_visual_style.dart';

class VisualStyleRepository {
  static const _boxName = 'settings';
  static const _key = 'visual_style';

  Future<AppVisualStyle> load() async {
    try {
      final box = await Hive.openBox<String>(_boxName);
      return appVisualStyleFromStorage(box.get(_key));
    } catch (_) {
      return AppVisualStyle.material;
    }
  }

  Future<void> save(AppVisualStyle style) async {
    final box = await Hive.openBox<String>(_boxName);
    await box.put(_key, style.name);
  }
}

class VisualStyleNotifier extends StateNotifier<AppVisualStyle> {
  VisualStyleNotifier(this._repository) : super(AppVisualStyle.material) {
    _load();
  }

  final VisualStyleRepository _repository;
  bool _changedByUser = false;

  Future<void> _load() async {
    final restored = await _repository.load();
    if (!_changedByUser) state = restored;
  }

  Future<void> setStyle(AppVisualStyle style) async {
    if (style == state) return;
    _changedByUser = true;
    state = style;
    await _repository.save(style);
  }
}

final visualStyleRepositoryProvider = Provider<VisualStyleRepository>((ref) {
  return VisualStyleRepository();
});

final visualStyleProvider =
    StateNotifierProvider<VisualStyleNotifier, AppVisualStyle>((ref) {
      return VisualStyleNotifier(ref.watch(visualStyleRepositoryProvider));
    });
