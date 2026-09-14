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

  testWidgets('fullscreen map fills a portrait viewport', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SizedBox(
          width: 390,
          height: 780,
          child: Campus3DMap(fullscreen: true),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    final viewport = tester.getSize(find.byType(InteractiveViewer));
    final canvas = tester.getSize(find.byKey(const Key('campus-map-canvas')));

    expect(canvas.height, greaterThanOrEqualTo(viewport.height));
    expect(canvas.width, greaterThan(viewport.width));
    expect(tester.takeException(), isNull);
  });
}
