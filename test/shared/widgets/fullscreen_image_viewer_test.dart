import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/shared/widgets/fullscreen_image_viewer.dart';

void main() {
  testWidgets('opens and closes fullscreen image viewer', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () => showFullscreenImageViewer(
                context,
                'https://example.com/image.jpg',
              ),
              child: const Text('Открыть'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Открыть'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(FullscreenImageViewer), findsOneWidget);
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.byTooltip('Закрыть'), findsOneWidget);

    await tester.tap(find.byTooltip('Закрыть'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(FullscreenImageViewer), findsNothing);
  });

  testWidgets('does nothing for empty image url', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () => showFullscreenImageViewer(context, ''),
              child: const Text('Открыть'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Открыть'));
    await tester.pump();

    expect(find.byType(FullscreenImageViewer), findsNothing);
  });
}
