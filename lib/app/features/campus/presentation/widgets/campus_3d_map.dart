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

class _Campus3DMapState extends State<Campus3DMap> {
  final _transformationController = TransformationController();
  CampusMapBuilding? _selectedBuilding;

  @override
  void dispose() {
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
    _transformationController.value = Matrix4.identity();
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
    final mapSurface = _buildMapSurface(
      scheme,
      showFullscreenButton: !widget.fullscreen,
    );
    final selectionDetails = _buildSelectionDetails(theme, scheme);

    if (widget.fullscreen) {
      return Column(
        children: [
          Expanded(child: mapSurface),
          selectionDetails,
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
                  Text('3D-схема кампуса', style: theme.textTheme.titleLarge),
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
            _MapBadge(
              icon: Icons.offline_bolt_rounded,
              label: 'Офлайн',
              color: scheme.primary,
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

  Widget _buildMapSurface(
    ColorScheme scheme, {
    required bool showFullscreenButton,
  }) {
    return ClipRRect(
      borderRadius: AppRadius.xxlBr,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.7),
          ),
          borderRadius: AppRadius.xxlBr,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 1,
                  maxScale: 5,
                  boundaryMargin: const EdgeInsets.all(80),
                  clipBehavior: Clip.hardEdge,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = constraints.biggest;
                      return Semantics(
                        label: 'Интерактивная трёхмерная схема кампуса',
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapUp: (details) =>
                              _selectBuilding(details.localPosition, size),
                          child: CustomPaint(
                            size: size,
                            painter: _CampusMapPainter(
                              colorScheme: scheme,
                              selectedBuildingId: _selectedBuilding?.id,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              child: _MapBadge(
                icon: Icons.view_in_ar_rounded,
                label: 'План кампуса',
                color: scheme.tertiary,
              ),
            ),
            if (showFullscreenButton)
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
                tooltip: 'Сбросить масштаб',
                onPressed: _resetView,
                icon: const Icon(Icons.center_focus_strong_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionDetails(ThemeData theme, ColorScheme scheme) {
    return AnimatedSwitcher(
      duration: AppDurations.fast,
      child: _selectedBuilding == null
          ? Padding(
              key: const ValueKey('map-help'),
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Text(
                'Нажмите на корпус, чтобы увидеть его название.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            )
          : Container(
              key: ValueKey(_selectedBuilding!.id),
              width: double.infinity,
              margin: const EdgeInsets.only(top: AppSpacing.md),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withValues(alpha: 0.55),
                borderRadius: AppRadius.lgBr,
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
      appBar: AppBar(title: const Text('План кампуса')),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Campus3DMap(fullscreen: true),
        ),
      ),
    );
  }
}

class _MapBadge extends StatelessWidget {
  const _MapBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: AppRadius.pillBr,
        boxShadow: const [BoxShadow(color: Color(0x18000000), blurRadius: 10)],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(label, style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
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

    _paintFacilities(canvas);

    for (final road in CampusMapLayout.roads) {
      final path = Path()..moveTo(road.points.first.dx, road.points.first.dy);
      for (final point in road.points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas
        ..drawPath(
          path,
          Paint()
            ..color = colorScheme.outlineVariant.withValues(alpha: 0.46)
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
                alpha: colorScheme.brightness == Brightness.dark ? 0.08 : 0.7,
              ),
              colorScheme.surface,
            )
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = road.width,
        );
    }

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
    _paintCompass(canvas);
    canvas.restore();
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
    _paintMapLabel(canvas, 'Стадион', const Offset(175, 444), maxWidth: 96);

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
      const Radius.circular(28),
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
        ..strokeWidth = 5,
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
          fontSize: compact ? 13 : 15,
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
    final sideColor = Color.alphaBlend(
      Colors.black.withValues(alpha: 0.18),
      roofColor,
    );
    final extrusion = Offset(5, building.height);
    final points = building.footprint;

    canvas.drawShadow(
      building.path.shift(extrusion),
      Colors.black.withValues(alpha: 0.38),
      selected ? 14 : 9,
      true,
    );
    for (var index = 0; index < points.length; index++) {
      final current = points[index];
      final next = points[(index + 1) % points.length];
      final side = Path()
        ..moveTo(current.dx, current.dy)
        ..lineTo(next.dx, next.dy)
        ..lineTo(next.dx + extrusion.dx, next.dy + extrusion.dy)
        ..lineTo(current.dx + extrusion.dx, current.dy + extrusion.dy)
        ..close();
      final isRightFace = next.dy > current.dy;
      canvas.drawPath(
        side,
        Paint()
          ..color = isRightFace
              ? Color.alphaBlend(
                  Colors.black.withValues(alpha: 0.08),
                  sideColor,
                )
              : sideColor,
      );
    }

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
          ..strokeWidth = selected ? 4 : 1.5,
      );

    final markerCenter = building.center;
    canvas
      ..drawCircle(
        markerCenter,
        22,
        Paint()
          ..color = selected
              ? colorScheme.primary
              : colorScheme.surface.withValues(alpha: 0.9),
      )
      ..drawCircle(
        markerCenter,
        22,
        Paint()
          ..color = selected
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.32)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${building.number}',
        style: TextStyle(
          color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
          fontSize: 20,
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

  void _paintCompass(Canvas canvas) {
    const center = Offset(820, 72);
    final color = colorScheme.onSurfaceVariant;
    canvas
      ..drawCircle(
        center,
        29,
        Paint()..color = colorScheme.surface.withValues(alpha: 0.82),
      )
      ..drawLine(
        center + const Offset(0, 17),
        center - const Offset(0, 13),
        Paint()
          ..color = color
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round,
      );
    final arrow = Path()
      ..moveTo(center.dx, center.dy - 22)
      ..lineTo(center.dx - 7, center.dy - 8)
      ..lineTo(center.dx + 7, center.dy - 8)
      ..close();
    canvas.drawPath(arrow, Paint()..color = colorScheme.primary);
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'N',
        style: TextStyle(
          color: color,
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, center + Offset(-textPainter.width / 2, 19));
  }

  @override
  bool shouldRepaint(covariant _CampusMapPainter oldDelegate) {
    return oldDelegate.colorScheme != colorScheme ||
        oldDelegate.selectedBuildingId != selectedBuildingId;
  }
}
