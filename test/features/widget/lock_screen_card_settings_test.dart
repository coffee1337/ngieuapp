import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/widget/lock_screen_card_settings.dart';

void main() {
  test('lock screen card state updates without losing load status', () {
    const initial = LockScreenCardState(enabled: false, loaded: true);
    final enabled = initial.copyWith(enabled: true);

    expect(enabled.enabled, isTrue);
    expect(enabled.loaded, isTrue);
  });
}
