import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/campus/domain/campus_catalog.dart';

void main() {
  test('resolves institute and floor from a standard room number', () {
    final result = CampusCatalog.resolveRoom('220');

    expect(result.isRecognized, isTrue);
    expect(
      result.institute?.name,
      'Институт информационных технологий '
      'и систем связи',
    );
    expect(result.floor, 3);
  });

  test('does not fabricate a location for a non-standard room', () {
    final result = CampusCatalog.resolveRoom('спортзал');

    expect(result.isRecognized, isFalse);
    expect(result.floor, isNull);
  });

  test('searches institutes by abbreviation offline', () {
    final result = CampusCatalog.searchInstitutes('ИИТиСС');

    expect(result, hasLength(1));
    expect(result.single.roomPrefix, '2xx');
  });
}
