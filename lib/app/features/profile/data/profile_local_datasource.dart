import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:ngieuapp/app/core/cache/hive_boxes.dart';
import 'package:ngieuapp/app/features/profile/domain/student_identity.dart';

class ProfileLocalDataSource {
  static const _key = 'student_identity';

  Future<StudentIdentity?> load() async {
    final box = await Hive.openBox<String>(HiveBoxes.profile);
    final raw = box.get(_key);
    if (raw == null) return null;
    return StudentIdentity.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(StudentIdentity identity) async {
    final box = await Hive.openBox<String>(HiveBoxes.profile);
    await box.put(_key, jsonEncode(identity.toJson()));
  }

  Future<void> clear() async {
    final box = await Hive.openBox<String>(HiveBoxes.profile);
    await box.delete(_key);
  }
}
