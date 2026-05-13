import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/schedule/domain/department.dart';

void main() {
  group('Department.fromJson', () {
    test('maps student institute id and name', () {
      final department = Department.fromJson({
        'id': 2,
        'name': 'Информационные технологии и системы связи',
      });

      expect(department.id, 2);
      expect(department.name, 'Информационные технологии и системы связи');
    });

    test('parses id from string', () {
      final department = Department.fromJson({
        'id': '4',
        'name': 'Педагогика и дополнительное образование',
      });

      expect(department.id, 4);
      expect(department.name, 'Педагогика и дополнительное образование');
    });
  });
}
