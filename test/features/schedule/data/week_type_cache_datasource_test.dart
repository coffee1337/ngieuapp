import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ngieuapp/app/core/cache/hive_boxes.dart';
import 'package:ngieuapp/app/features/schedule/data/week_type_cache_datasource.dart';
import 'package:ngieuapp/app/features/schedule/domain/week_type.dart';

void main() {
  late Directory directory;
  final source = WeekTypeCacheDataSource();

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('week_cache_test_');
    Hive.init(directory.path);
  });
  tearDown(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test('keeps independent weeks and clears all week entries', () async {
    final first = WeekType(date: DateTime(2025, 3, 10), isUpperWeek: true);
    final second = WeekType(date: DateTime(2025, 3, 17), isUpperWeek: false);
    await source.saveWeekType(first);
    await source.saveWeekType(second);
    expect(await source.loadWeekType(date: DateTime(2025, 3, 12)), first);
    expect(await source.loadWeekType(date: second.date), second);
    expect(await source.loadWeekType(date: DateTime(2025, 4, 1)), isNull);
    final box = await Hive.openBox<String>(HiveBoxes.scheduleCache);
    await box.put('unrelated', 'preserve');
    await source.clearCache();
    expect(await source.loadWeekType(date: first.date), isNull);
    expect(box.get('unrelated'), 'preserve');
  });
}
