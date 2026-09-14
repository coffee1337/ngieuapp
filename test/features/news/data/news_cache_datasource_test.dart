import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ngieuapp/app/core/cache/hive_boxes.dart';
import 'package:ngieuapp/app/features/news/data/news_cache_datasource.dart';

void main() {
  late Directory directory;
  final source = NewsCacheDataSource();

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('news_cache_test_');
    Hive.init(directory.path);
  });
  tearDown(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test('discards corrupt list JSON and invalid model data', () async {
    final box = await Hive.openBox<String>(HiveBoxes.newsList);
    for (final raw in ['{invalid', '[{"id":"wrong type"}]']) {
      await box.put('page_1', raw);
      expect((await source.loadList(1)).items, isEmpty);
      expect(box.containsKey('page_1'), isFalse);
    }
  });

  test('discards a corrupt detail instead of blocking API fallback', () async {
    final box = await Hive.openBox<String>(HiveBoxes.newsDetail);
    await box.put('42', '{"preview":null}');
    expect(await source.loadDetail(42), isNull);
    expect(box.containsKey('42'), isFalse);
  });
}
