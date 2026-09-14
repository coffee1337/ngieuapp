import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

Future<void> showFullscreenImageViewer(BuildContext context, String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Future<void>.value();
  }

  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: true,
      transitionDuration: const Duration(milliseconds: 180),
      reverseTransitionDuration: const Duration(milliseconds: 140),
      pageBuilder: (_, animation, __) =>
          FullscreenImageViewer(imageUrl: imageUrl),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
    ),
  );
}

class FullscreenImageViewer extends StatefulWidget {
  const FullscreenImageViewer({required this.imageUrl, super.key});

  final String imageUrl;

  @override
  State<FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<FullscreenImageViewer> {
  final _photoController = PhotoViewController();
  final _scaleStateController = PhotoViewScaleStateController();
  bool _controlsVisible = true;

  @override
  void dispose() {
    _photoController.dispose();
    _scaleStateController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _photoController.reset();
    _scaleStateController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: PhotoView(
              key: const Key('fullscreen-photo-view'),
              imageProvider: CachedNetworkImageProvider(widget.imageUrl),
              controller: _photoController,
              scaleStateController: _scaleStateController,
              initialScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained * 0.85,
              maxScale: PhotoViewComputedScale.covered * 4,
              basePosition: Alignment.center,
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              heroAttributes: PhotoViewHeroAttributes(
                tag: 'news-image-${widget.imageUrl}',
              ),
              filterQuality: FilterQuality.high,
              onTapUp: (_, __, ___) =>
                  setState(() => _controlsVisible = !_controlsVisible),
              loadingBuilder: (_, __) => const Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                ),
              ),
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.white70,
                  size: 48,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: IgnorePointer(
                ignoring: !_controlsVisible,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOutCubic,
                  offset: _controlsVisible
                      ? Offset.zero
                      : const Offset(0, -1.4),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 120),
                    opacity: _controlsVisible ? 1 : 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton.filled(
                            key: const Key('fullscreen-image-close'),
                            tooltip: 'Закрыть',
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                          IconButton.filledTonal(
                            key: const Key('fullscreen-image-reset'),
                            tooltip: 'Сбросить масштаб',
                            onPressed: _resetZoom,
                            icon: const Icon(Icons.center_focus_strong_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_controlsVisible)
            const Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: IgnorePointer(
                child: SafeArea(
                  child: Text(
                    'Двойное касание — приблизить · жест двумя пальцами — масштаб',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
