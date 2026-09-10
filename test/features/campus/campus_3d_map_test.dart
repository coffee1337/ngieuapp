import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/campus/presentation/widgets/campus_3d_map.dart';

void main() {
  testWidgets('opens the campus plan on a dedicated fullscreen route', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Campus3DMap(),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Открыть на весь экран'));
    await tester.pumpAndSettle();

    expect(find.byType(CampusMapFullscreenScreen), findsOneWidget);
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.text('План кампуса'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
