import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/schedule/domain/actor.dart';
import 'package:ngieuapp/app/features/schedule/domain/favorite_actor.dart';

void main() {
  group('FavoriteActor', () {
    test('serializes student group', () {
      const actor = FavoriteActor(
        id: 'group-1',
        name: 'Б-22 ИСТ',
        type: ActorType.studentGroup,
        departmentId: 11,
        departmentName: 'Информационные системы и технологии',
      );

      expect(FavoriteActor.fromJson(actor.toJson()), actor);
    });

    test('serializes teacher', () {
      const actor = FavoriteActor(
        id: 'teacher-1',
        name: 'Иванов И.И.',
        type: ActorType.teacher,
        departmentId: 8,
        departmentName: 'Математика и вычислительная техника',
      );

      expect(FavoriteActor.fromJson(actor.toJson()), actor);
      expect(actor.isSupported, isTrue);
    });

    test('marks department actor as unsupported', () {
      const actor = FavoriteActor(
        id: 'department-1',
        name: 'Кафедра',
        type: ActorType.department,
        departmentId: 8,
        departmentName: 'Математика и вычислительная техника',
      );

      expect(actor.isSupported, isFalse);
    });
  });
}
