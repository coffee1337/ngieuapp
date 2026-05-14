import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Future<void> showFullscreenImageViewer(BuildContext context, String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Future<void>.value();
  }

  return Navigator.of(context).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => FullscreenImageViewer(imageUrl: imageUrl),
    ),
  );
}

class FullscreenImageViewer extends StatelessWidget {
  const FullscreenImageViewer({required this.imageUrl, super.key});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (_, __) => const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (_, __, ___) => const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.white70,
                    size: 48,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton.filled(
                tooltip: 'Закрыть',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
