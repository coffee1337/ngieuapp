import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/shared/widgets/fullscreen_image_viewer.dart';
import 'package:photo_view/photo_view.dart';

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
    expect(find.byType(PhotoView), findsOneWidget);
    expect(find.byTooltip('Закрыть'), findsOneWidget);

    await tester.tap(find.byKey(const Key('fullscreen-image-close')));
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

  testWidgets('uses a photo controller and reset restores the image', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FullscreenImageViewer(imageUrl: 'https://example.com/image.jpg'),
      ),
    );

    final photoView = tester.widget<PhotoView>(
      find.byKey(const Key('fullscreen-photo-view')),
    );
    final controller = photoView.controller! as PhotoViewController;
    controller.scale = 2.5;
    expect(controller.value.scale, 2.5);

    await tester.tap(find.byKey(const Key('fullscreen-image-reset')));
    await tester.pump();
    expect(controller.value.scale, isNot(2.5));
  });
}
