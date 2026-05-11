import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveCache {
  Future<Box<T>> openBox<T>(String name) => Hive.openBox<T>(name);
}

final hiveCacheProvider = Provider<HiveCache>((ref) => HiveCache());
