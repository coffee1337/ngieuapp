import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/schedule/domain/usecases/find_smart_gaps.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  const findGaps = FindSmartGaps();
  final day = DateTime(2025, 3, 10);

  test('finds a free interval between lessons', () {
    final gaps = findGaps(
      lessons: [
        makeLesson(
          id: 'first',
          date: day,
          startTime: DateTime(2025, 3, 10, 8, 30),
          endTime: DateTime(2025, 3, 10, 10),
        ),
        makeLesson(
          id: 'second',
          date: day,
          startTime: DateTime(2025, 3, 10, 11, 30),
          endTime: DateTime(2025, 3, 10, 13),
        ),
      ],
    );

    expect(gaps, hasLength(1));
    expect(gaps.single.duration, const Duration(minutes: 90));
    expect(gaps.single.previousLesson.id, 'first');
    expect(gaps.single.nextLesson.id, 'second');
  });

  test('uses the end of overlapping lessons as the start of a gap', () {
    final gaps = findGaps(
      lessons: [
        makeLesson(
          id: 'first',
          date: day,
          startTime: DateTime(2025, 3, 10, 8, 30),
          endTime: DateTime(2025, 3, 10, 10),
        ),
        makeLesson(
          id: 'overlap',
          date: day,
          startTime: DateTime(2025, 3, 10, 9, 30),
          endTime: DateTime(2025, 3, 10, 10, 30),
        ),
        makeLesson(
          id: 'next',
          date: day,
          startTime: DateTime(2025, 3, 10, 12),
          endTime: DateTime(2025, 3, 10, 13, 30),
        ),
      ],
    );

    expect(gaps.single.start, DateTime(2025, 3, 10, 10, 30));
    expect(gaps.single.previousLesson.id, 'overlap');
  });

  test('does not join lessons from different days', () {
    final gaps = findGaps(
      lessons: [
        makeLesson(id: 'monday', date: day),
        makeLesson(id: 'tuesday', date: day.add(const Duration(days: 1))),
      ],
    );

    expect(gaps, isEmpty);
  });
}
