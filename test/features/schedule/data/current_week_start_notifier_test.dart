import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';

void main() {
  test('coalesces rapid week navigation into the latest week', () async {
    final initial = DateTime(2026, 9, 7);
    final notifier = CurrentWeekStartNotifier(
      initialDate: initial,
      navigationDebounce: const Duration(milliseconds: 20),
    );
    addTearDown(notifier.dispose);

    notifier
      ..nextWeek()
      ..nextWeek()
      ..nextWeek()
      ..prevWeek();

    expect(notifier.state, initial.add(const Duration(days: 7)));
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(notifier.state, initial.add(const Duration(days: 14)));
  });

  test('date selection cancels pending navigation', () async {
    final notifier = CurrentWeekStartNotifier(
      initialDate: DateTime(2026, 9, 7),
      navigationDebounce: const Duration(milliseconds: 20),
    );
    addTearDown(notifier.dispose);

    notifier
      ..nextWeek()
      ..nextWeek()
      ..setDate(DateTime(2026, 10, 21));

    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(notifier.state, DateTime(2026, 10, 19));
  });
}
