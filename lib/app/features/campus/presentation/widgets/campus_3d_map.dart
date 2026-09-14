import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:ngieuapp/app/features/campus/domain/campus_map_layout.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class Campus3DMap extends StatefulWidget {
  const Campus3DMap({super.key, this.fullscreen = false});

  final bool fullscreen;

  @override
  State<Campus3DMap> createState() => _Campus3DMapState();
}

class _Campus3DMapState extends State<Campus3DMap>
    with SingleTickerProviderStateMixin {
  final _transformationController = TransformationController();
  late final AnimationController _resetController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );
  Animation<Matrix4>? _resetAnimation;
  CampusMapBuilding? _selectedBuilding;

  @override
  void dispose() {
    _resetController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _selectBuilding(Offset point, Size size) {
    final scale = math.min(
      size.width / CampusMapLayout.canvasSize.width,
      size.height / CampusMapLayout.canvasSize.height,
    );
    final origin = Offset(
      (size.width - CampusMapLayout.canvasSize.width * scale) / 2,
      (size.height - CampusMapLayout.canvasSize.height * scale) / 2,
    );
    final layoutPoint = Offset(
      (point.dx - origin.dx) / scale,
      (point.dy - origin.dy) / scale,
    );
    setState(() {
      _selectedBuilding = CampusMapLayout.hitTest(layoutPoint);
    });
  }

  void _resetView() {
    _resetAnimation =
        Matrix4Tween(
            begin: _transformationController.value,
            end: Matrix4.identity(),
          ).animate(
            CurvedAnimation(
              parent: _resetController,
              curve: Curves.easeOutCubic,
            ),
          )
          ..addListener(() {
            _transformationController.value = _resetAnimation!.value;
          });
    _resetController.forward(from: 0);
    setState(() => _selectedBuilding = null);
  }

  void _openFullscreen() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const CampusMapFullscreenScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final mapSurface = _buildMapSurface(scheme);
    final selectionDetails = _buildSelectionDetails(theme, scheme);

    if (widget.fullscreen) {
      return Stack(
        children: [
          Positioned.fill(child: mapSurface),
          if (_selectedBuilding != null)
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: 28,
              child: SafeArea(top: false, child: selectionDetails),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Интерактивный план кампуса',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Двигайте и масштабируйте двумя пальцами',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Chip(
              avatar: Icon(
                Icons.offline_bolt_rounded,
                size: 16,
                color: scheme.primary,
              ),
              label: const Text('Офлайн'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AspectRatio(
          aspectRatio:
              CampusMapLayout.canvasSize.width /
              CampusMapLayout.canvasSize.height,
          child: mapSurface,
        ),
        selectionDetails,
      ],
    );
  }

  Widget _buildMapSurface(ColorScheme scheme) {
    final borderRadius = widget.fullscreen
        ? BorderRadius.zero
        : AppRadius.xxlBr;
    return ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          border: widget.fullscreen
              ? null
              : Border.all(color: scheme.outlineVariant.withValues(alpha: 0.7)),
          borderRadius: borderRadius,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final viewport = constraints.biggest;
            final widthScale =
                viewport.width / CampusMapLayout.canvasSize.width;
            final heightScale =
                viewport.height / CampusMapLayout.canvasSize.height;
            final initialScale = widget.fullscreen
                ? math.max(widthScale, heightScale)
                : math.min(widthScale, heightScale);
            final mapSize = Size(
              CampusMapLayout.canvasSize.width * initialScale,
              CampusMapLayout.canvasSize.height * initialScale,
            );
            return Stack(
              children: [
                Positioned.fill(
                  child: RepaintBoundary(
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: Transform.scale(
                          scale: 0.985 + value * 0.015,
                          child: child,
                        ),
                      ),
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        constrained: false,
                        alignment: Alignment.center,
                        minScale: 1,
                        maxScale: 4.5,
                        boundaryMargin: const EdgeInsets.all(120),
                        clipBehavior: Clip.hardEdge,
                        onInteractionStart: (_) => _resetController.stop(),
                        child: SizedBox.fromSize(
                          key: const Key('campus-map-canvas'),
                          size: mapSize,
                          child: Semantics(
                            label: 'Интерактивный план кампуса НГИЭУ',
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapUp: (details) => _selectBuilding(
                                details.localPosition,
                                mapSize,
                              ),
                              child: CustomPaint(
                                size: mapSize,
                                painter: _CampusMapPainter(
                                  colorScheme: scheme,
                                  selectedBuildingId: _selectedBuilding?.id,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (!widget.fullscreen)
                  Positioned(
                    top: AppSpacing.md,
                    right: AppSpacing.md,
                    child: IconButton.filledTonal(
                      tooltip: 'Открыть на весь экран',
                      onPressed: _openFullscreen,
                      icon: const Icon(Icons.fullscreen_rounded),
                    ),
                  ),
                Positioned(
                  right: AppSpacing.md,
                  bottom: AppSpacing.md,
                  child: IconButton.filledTonal(
                    tooltip: 'Показать весь кампус',
                    onPressed: _resetView,
                    icon: const Icon(Icons.center_focus_strong_rounded),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectionDetails(ThemeData theme, ColorScheme scheme) {
    return AnimatedSwitcher(
      duration: AppDurations.fast,
      child: _selectedBuilding == null
          ? const SizedBox.shrink(key: ValueKey('map-help'))
          : Container(
              key: ValueKey(_selectedBuilding!.id),
              width: double.infinity,
              margin: widget.fullscreen
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(top: AppSpacing.md),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: scheme.surface.withValues(alpha: 0.94),
                borderRadius: AppRadius.lgBr,
                border: Border.all(
                  color: scheme.outlineVariant.withValues(alpha: 0.75),
                ),
                boxShadow: const [
                  BoxShadow(color: Color(0x26000000), blurRadius: 18),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.apartment_rounded, color: scheme.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      _selectedBuilding!.name ??
                          'Здание ${_selectedBuilding!.number}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    '№${_selectedBuilding!.number}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class CampusMapFullscreenScreen extends StatelessWidget {
  const CampusMapFullscreenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.surface.withValues(alpha: 0.9),
        title: const Text('План кампуса'),
      ),
      body: const Campus3DMap(fullscreen: true),
    );
  }
}

class _CampusMapPainter extends CustomPainter {
  const _CampusMapPainter({
    required this.colorScheme,
    required this.selectedBuildingId,
  });

  final ColorScheme colorScheme;
  final String? selectedBuildingId;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = colorScheme.surfaceContainerLow,
    );
    final scale = math.min(
      size.width / CampusMapLayout.canvasSize.width,
      size.height / CampusMapLayout.canvasSize.height,
    );
    final origin = Offset(
      (size.width - CampusMapLayout.canvasSize.width * scale) / 2,
      (size.height - CampusMapLayout.canvasSize.height * scale) / 2,
    );
    canvas
      ..save()
      ..translate(origin.dx, origin.dy)
      ..scale(scale);

    final grassPaint = Paint()
      ..color = Color.alphaBlend(
        const Color(0xFF8DBA67).withValues(
          alpha: colorScheme.brightness == Brightness.dark ? 0.22 : 0.3,
        ),
        colorScheme.surfaceContainerLow,
      );
    final grassOutline = Paint()
      ..color = const Color(0xFF72A950).withValues(alpha: 0.38)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final points in CampusMapLayout.greenZones) {
      final path = Path()..addPolygon(points, true);
      canvas
        ..drawPath(path, grassPaint)
        ..drawPath(path, grassOutline);
    }

    for (final road in CampusMapLayout.roads) {
      final path = _buildRoadPath(road.points);
      canvas
        ..drawPath(
          path,
          Paint()
            ..color = Colors.black.withValues(alpha: 0.1)
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = road.width + 5,
        )
        ..drawPath(
          path,
          Paint()
            ..color = Color.alphaBlend(
              Colors.white.withValues(
                alpha: colorScheme.brightness == Brightness.dark ? 0.1 : 0.9,
              ),
              colorScheme.surfaceContainerHigh,
            )
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = road.width,
        );
    }

    _paintFacilities(canvas);

    for (final building in CampusMapLayout.buildings) {
      _paintBuilding(canvas, building);
    }
    for (final building in CampusMapLayout.buildings) {
      final name = building.name;
      final anchor = building.labelAnchor;
      if (name != null && anchor != null) {
        _paintMapLabel(canvas, name, anchor, maxWidth: 190);
      }
    }
    canvas.restore();
  }

  Path _buildRoadPath(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    return path;
  }

  void _paintFacilities(Canvas canvas) {
    final lineColor = colorScheme.outline.withValues(alpha: 0.55);
    final sportsColor = Color.alphaBlend(
      const Color(0xFF78A85D).withValues(alpha: 0.22),
      colorScheme.surfaceContainerLow,
    );

    final stadium = RRect.fromRectAndRadius(
      const Rect.fromLTRB(107, 313, 243, 590),
      const Radius.circular(70),
    );
    final stadiumInner = RRect.fromRectAndRadius(
      const Rect.fromLTRB(120, 330, 230, 572),
      const Radius.circular(58),
    );
    canvas
      ..drawRRect(stadium, Paint()..color = sportsColor)
      ..drawRRect(
        stadium,
        Paint()
          ..color = const Color(0xFF659E4C).withValues(alpha: 0.72)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      )
      ..drawRRect(
        stadiumInner,
        Paint()
          ..color = const Color(0xFF659E4C).withValues(alpha: 0.48)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    for (var y = 365.0; y <= 535; y += 42) {
      canvas.drawLine(
        Offset(125, y),
        Offset(225, y),
        Paint()
          ..color = const Color(0xFF659E4C).withValues(alpha: 0.25)
          ..strokeWidth = 1,
      );
    }
    _paintMapLabel(
      canvas,
      'Стадион',
      const Offset(175, 444),
      maxWidth: 110,
      compact: true,
    );

    final volleyballCourt = RRect.fromRectAndRadius(
      const Rect.fromLTRB(107, 265, 177, 304),
      const Radius.circular(5),
    );
    canvas
      ..drawRRect(volleyballCourt, Paint()..color = sportsColor)
      ..drawRRect(
        volleyballCourt,
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      )
      ..drawLine(
        const Offset(142, 266),
        const Offset(142, 303),
        Paint()
          ..color = lineColor
          ..strokeWidth = 1.5,
      );
    _paintMapLabel(
      canvas,
      'Волейбольная площадка',
      const Offset(142, 251),
      maxWidth: 130,
      compact: true,
    );

    final equipmentPaint = Paint()
      ..color = colorScheme.tertiary.withValues(alpha: 0.75)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (final x in [194.0, 211.0, 228.0]) {
      canvas
        ..drawLine(Offset(x, 274), Offset(x, 296), equipmentPaint)
        ..drawLine(Offset(x - 5, 280), Offset(x + 5, 280), equipmentPaint)
        ..drawCircle(Offset(x, 270), 3, equipmentPaint);
    }
    _paintMapLabel(
      canvas,
      'Тренажёры',
      const Offset(211, 311),
      maxWidth: 92,
      compact: true,
    );

    final sportsBox = RRect.fromRectAndRadius(
      const Rect.fromLTRB(248, 49, 404, 123),
      const Radius.circular(18),
    );
    canvas
      ..drawRRect(
        sportsBox,
        Paint()
          ..color = const Color(0xFF659E4C).withValues(alpha: 0.58)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      )
      ..drawLine(
        const Offset(326, 51),
        const Offset(326, 121),
        Paint()
          ..color = const Color(0xFF659E4C).withValues(alpha: 0.38)
          ..strokeWidth = 1.5,
      );
    _paintMapLabel(
      canvas,
      'Спортивная коробка',
      const Offset(326, 85),
      maxWidth: 135,
      compact: true,
    );

    final drivingTrack = Path()
      ..moveTo(512, 92)
      ..lineTo(743, 87)
      ..quadraticBezierTo(787, 88, 790, 126)
      ..lineTo(790, 178)
      ..quadraticBezierTo(787, 195, 760, 197)
      ..lineTo(524, 201)
      ..quadraticBezierTo(507, 197, 508, 180)
      ..lineTo(508, 112)
      ..quadraticBezierTo(507, 99, 512, 92)
      ..close();
    canvas.drawPath(
      drivingTrack,
      Paint()
        ..color = colorScheme.outlineVariant.withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7,
    );
    final conePaint = Paint()..color = colorScheme.tertiary;
    for (final point in const [
      Offset(562, 145),
      Offset(620, 119),
      Offset(681, 164),
      Offset(740, 132),
    ]) {
      final cone = Path()
        ..moveTo(point.dx, point.dy - 5)
        ..lineTo(point.dx - 5, point.dy + 5)
        ..lineTo(point.dx + 5, point.dy + 5)
        ..close();
      canvas.drawPath(cone, conePaint);
    }
    _paintMapLabel(
      canvas,
      'Площадка для вождения',
      const Offset(649, 177),
      maxWidth: 150,
      compact: true,
    );
  }

  void _paintMapLabel(
    Canvas canvas,
    String text,
    Offset anchor, {
    required double maxWidth,
    bool compact = false,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: compact ? 17 : 19,
          height: 1.15,
          fontWeight: compact ? FontWeight.w600 : FontWeight.w700,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
      maxLines: 3,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth);
    final offset = Offset(
      anchor.dx - textPainter.width / 2,
      anchor.dy - textPainter.height / 2,
    );
    final background = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        offset.dx - 5,
        offset.dy - 3,
        textPainter.width + 10,
        textPainter.height + 6,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(
      background,
      Paint()..color = colorScheme.surface.withValues(alpha: 0.84),
    );
    textPainter.paint(canvas, offset);
  }

  void _paintBuilding(Canvas canvas, CampusMapBuilding building) {
    final selected = building.id == selectedBuildingId;
    final baseRoofColor = switch (building.tone) {
      CampusBuildingTone.academic => const Color(0xFFE7E1D5),
      CampusBuildingTone.residence => const Color(0xFFEEE8D9),
      CampusBuildingTone.utility => const Color(0xFFD4D6D7),
    };
    final roofColor = selected
        ? colorScheme.primaryContainer
        : Color.alphaBlend(
            baseRoofColor.withValues(
              alpha: colorScheme.brightness == Brightness.dark ? 0.3 : 0.88,
            ),
            colorScheme.surfaceContainerHigh,
          );
    canvas.drawShadow(
      building.path.shift(const Offset(0, 3)),
      Colors.black.withValues(alpha: 0.28),
      selected ? 12 : 7,
      true,
    );
    final roofBounds = building.path.getBounds();
    final roofPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.alphaBlend(Colors.white.withValues(alpha: 0.22), roofColor),
          roofColor,
        ],
      ).createShader(roofBounds);
    canvas
      ..drawPath(building.path, roofPaint)
      ..drawPath(
        building.path,
        Paint()
          ..color = selected
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.42)
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected ? 4 : 1.4,
      );

    final markerCenter = building.center;
    canvas
      ..drawCircle(
        markerCenter,
        17,
        Paint()
          ..color = selected
              ? colorScheme.primary
              : const Color(0xFF1D2025).withValues(alpha: 0.9),
      )
      ..drawCircle(
        markerCenter,
        17,
        Paint()
          ..color = Colors.white.withValues(alpha: selected ? 0.8 : 0.34)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${building.number}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      markerCenter - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _CampusMapPainter oldDelegate) {
    return oldDelegate.colorScheme != colorScheme ||
        oldDelegate.selectedBuildingId != selectedBuildingId;
  }
}
