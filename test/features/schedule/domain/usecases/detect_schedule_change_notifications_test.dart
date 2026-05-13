import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/schedule/domain/usecases/detect_schedule_change_notifications.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  const sut = DetectScheduleChangeNotifications();
  const actorId = 'actor-1';
  final now = DateTime(2025, 3, 10, 12);

  group('DetectScheduleChangeNotifications', () {
    test('new change creates notification candidate', () {
      final change = makeLesson(
        id: 'change',
        date: DateTime(2025, 3, 10),
        isChange: true,
        classroom: '205',
      );

      final result = sut(
        actorId: actorId,
        oldLessons: const [],
        freshLessons: [change],
        now: now,
      );

      expect(result, hasLength(1));
      expect(result.first.lesson, change);
      expect(result.first.fingerprint, isNotEmpty);
    });

    test('already known change does not create notification candidate', () {
      final change = makeLesson(
        id: 'change',
        date: DateTime(2025, 3, 10),
        isChange: true,
        classroom: '205',
      );

      final result = sut(
        actorId: actorId,
        oldLessons: [change],
        freshLessons: [change],
        now: now,
      );

      expect(result, isEmpty);
    });

    test('already sent change does not create notification candidate', () {
      final change = makeLesson(
        id: 'change',
        date: DateTime(2025, 3, 11),
        isChange: true,
        classroom: '205',
      );
      final fingerprint = DetectScheduleChangeNotifications.fingerprintFor(
        actorId,
        change,
      );

      final result = sut(
        actorId: actorId,
        oldLessons: const [],
        freshLessons: [change],
        now: now,
        sentFingerprints: {fingerprint},
      );

      expect(result, isEmpty);
    });

    test(
      'regular lesson without change does not create notification candidate',
      () {
        final regular = makeLesson(
          id: 'regular',
          date: DateTime(2025, 3, 10),
        );

        final result = sut(
          actorId: actorId,
          oldLessons: const [],
          freshLessons: [regular],
          now: now,
        );

        expect(result, isEmpty);
      },
    );
  });
}
