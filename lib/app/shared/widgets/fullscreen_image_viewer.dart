import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Future<void> showFullscreenImageViewer(BuildContext context, String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Future<void>.value();
  }

  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
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

class _FullscreenImageViewerState extends State<FullscreenImageViewer>
    with SingleTickerProviderStateMixin {
  final _transformationController = TransformationController();
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );
  Animation<Matrix4>? _matrixAnimation;
  TapDownDetails? _doubleTapDetails;
  Timer? _singleTapTimer;
  final Set<int> _activePointers = <int>{};
  Offset? _pointerDownPosition;
  bool _pointerMoved = false;
  bool _controlsVisible = true;

  @override
  void dispose() {
    _singleTapTimer?.cancel();
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _animateTo(Matrix4 target) {
    _matrixAnimation =
        Matrix4Tween(
            begin: _transformationController.value,
            end: target,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOutCubic,
            ),
          )
          ..addListener(() {
            _transformationController.value = _matrixAnimation!.value;
          });
    _animationController.forward(from: 0);
  }

  void _handleDoubleTap() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale > 1.05) {
      _animateTo(Matrix4.identity());
      return;
    }
    final position = _doubleTapDetails?.localPosition ?? Offset.zero;
    const scale = 2.5;
    _animateTo(
      Matrix4.identity()
        ..translate(-position.dx * (scale - 1), -position.dy * (scale - 1))
        ..scale(scale),
    );
  }

  void _handleImageTap(Offset position) {
    final pendingTap = _singleTapTimer;
    if (pendingTap?.isActive ?? false) {
      pendingTap!.cancel();
      _doubleTapDetails = TapDownDetails(localPosition: position);
      _handleDoubleTap();
      return;
    }
    _singleTapTimer = Timer(const Duration(milliseconds: 240), () {
      if (mounted) setState(() => _controlsVisible = !_controlsVisible);
    });
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_activePointers.isEmpty) {
      _pointerDownPosition = event.localPosition;
      _pointerMoved = false;
    }
    _activePointers.add(event.pointer);
    if (_activePointers.length > 1) _pointerMoved = true;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    final origin = _pointerDownPosition;
    if (origin != null && (event.localPosition - origin).distance > 12) {
      _pointerMoved = true;
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    _activePointers.remove(event.pointer);
    if (_activePointers.isEmpty && !_pointerMoved) {
      _handleImageTap(event.localPosition);
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _activePointers.remove(event.pointer);
    if (_activePointers.isEmpty) _pointerMoved = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Listener(
              key: const Key('fullscreen-image-gesture'),
              behavior: HitTestBehavior.opaque,
              onPointerDown: _handlePointerDown,
              onPointerMove: _handlePointerMove,
              onPointerUp: _handlePointerUp,
              onPointerCancel: _handlePointerCancel,
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.8,
                maxScale: 5,
                boundaryMargin: const EdgeInsets.all(48),
                clipBehavior: Clip.none,
                onInteractionStart: (_) => _animationController.stop(),
                child: SizedBox.expand(
                  child: Hero(
                    tag: 'news-image-${widget.imageUrl}',
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.contain,
                      fadeInDuration: const Duration(milliseconds: 160),
                      placeholder: (_, __) => const Center(
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.white70,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
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
                            onPressed: () => _animateTo(Matrix4.identity()),
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
