import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/shared/widgets/app_launch_splash.dart';

void main() {
  testWidgets('shows the animated brand screen and then reveals the app', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppLaunchSplash(
          child: Scaffold(body: Center(child: Text('Приложение готово'))),
        ),
      ),
    );

    expect(find.text('НГИЭУ'), findsOneWidget);
    expect(find.text('Приложение готово'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pump();

    expect(find.text('НГИЭУ'), findsNothing);
    expect(find.text('Приложение готово'), findsOneWidget);
  });
}
