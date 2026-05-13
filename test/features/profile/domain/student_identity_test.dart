import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/profile/domain/student_identity.dart';
import 'package:ngieuapp/app/features/schedule/domain/actor.dart';

void main() {
  group('StudentIdentity', () {
    test('migrates legacy student json', () {
      final identity = StudentIdentity.fromJson({
        'actorId': 'group-id',
        'groupName': 'Б-22 ИСТ',
        'departmentId': 2,
      });

      expect(identity.actorId, 'group-id');
      expect(identity.displayName, 'Б-22 ИСТ');
      expect(identity.actorType, ActorType.studentGroup);
      expect(identity.groupName, 'Б-22 ИСТ');
      expect(identity.departmentId, 2);
      expect(identity.departmentName, 'Кафедра №2');
    });

    test('serializes teacher identity', () {
      const identity = StudentIdentity(
        actorId: '101',
        displayName: 'Иванов И.И.',
        actorType: ActorType.teacher,
        departmentName: 'Математика и вычислительная техника',
        departmentId: 8,
      );

      expect(identity.computedCourse, isNull);
      expect(identity.toJson(), {
        'actorId': '101',
        'displayName': 'Иванов И.И.',
        'actorType': 'teacher',
        'departmentName': 'Математика и вычислительная техника',
        'groupName': null,
        'departmentId': 8,
        'fullName': null,
      });
    });
  });
}
