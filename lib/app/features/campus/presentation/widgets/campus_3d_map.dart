import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:ngieuapp/app/features/campus/domain/campus_map_layout.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class Campus3DMap extends StatefulWidget {
  const Campus3DMap({
    super.key,
    this.fullscreen = false,
    this.routePoints = const [],
  });

  final bool fullscreen;
  final List<Offset> routePoints;

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
  Size? _viewport;
  bool _didFit = false;
  bool _userMoved = false;

  @override
  void dispose() {
    _resetController
      ..removeListener(_applyResetFrame)
      ..dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _selectBuilding(Offset point) {
    setState(() => _selectedBuilding = CampusMapLayout.hitTest(point));
  }

  Matrix4 _fittedTransform(Size viewport) {
    final scale = math.min(
      viewport.width / CampusMapLayout.canvasSize.width,
      viewport.height / CampusMapLayout.canvasSize.height,
    );
    final horizontalOffset =
        (viewport.width - CampusMapLayout.canvasSize.width * scale) / 2;
    final verticalOffset =
        (viewport.height - CampusMapLayout.canvasSize.height * scale) / 2;
    // Порядок важен: сначала сдвиг, потом равномерный масштаб всех трёх осей
    // (как устаревший scale(s)). Если масштабировать по осям раздельно,
    // getMaxScaleOnAxis() вернёт 1.0 и карта «не впишется» во вьюпорт.
    return Matrix4.identity()
      ..translateByDouble(horizontalOffset, verticalOffset, 0, 1)
      ..scaleByDouble(scale, scale, scale, 1);
  }

  void _fitForViewport(Size viewport) {
    if (_viewport == viewport && _didFit) return;
    final first = !_didFit;
    _viewport = viewport;
    _didFit = true;
    if (!first && _userMoved) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _viewport != viewport) return;
      _transformationController.value = _fittedTransform(viewport);
    });
  }

  void _resetView() {
    final viewport = _viewport;
    if (viewport == null) return;
    _resetBegin = _transformationController.value.clone();
    _resetEnd = _fittedTransform(viewport);
    _resetController.forward(from: 0);
    setState(() => _selectedBuilding = null);
    _userMoved = false;
  }

  void _applyResetFrame() {
    final begin = _resetBegin;
    final end = _resetEnd;
    if (begin == null || end == null) return;
    final eased = Curves.easeOutCubic.transform(_resetController.value);
    _transformationController.value = Matrix4Tween(
      begin: begin,
      end: end,
    ).transform(eased);
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
            _fitForViewport(viewport);
            return Stack(
              children: [
                Positioned.fill(
                  child: RepaintBoundary(
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: child,
                      ),
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        constrained: false,
                        alignment: Alignment.topLeft,
                        minScale: 0.25,
                        maxScale: 3,
                        boundaryMargin: const EdgeInsets.all(double.infinity),
                        onInteractionStart: (_) {
                          _resetController.stop();
                          _userMoved = true;
                        },
                        child: SizedBox.fromSize(
                          key: const Key('campus-map-canvas'),
                          size: CampusMapLayout.canvasSize,
                          child: Semantics(
                            label: 'Интерактивный план кампуса НГИЭУ',
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapUp: (details) =>
                                  _selectBuilding(details.localPosition),
                              child: CustomPaint(
                                size: CampusMapLayout.canvasSize,
                                painter: _CampusMapPainter(
                                  colorScheme: scheme,
                                  selectedBuildingId: _selectedBuilding?.id,
                                  routePoints: widget.routePoints,
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
  _CampusMapPainter({
    required this.colorScheme,
    required this.selectedBuildingId,
    required this.routePoints,
  })  : _greenPaths = [
          for (final zone in CampusMapLayout.greenZones)
            Path()..addPolygon(zone, true),
        ],
        _roadPaths = [
          for (final road in CampusMapLayout.roads) _buildRoadPath(road.points),
        ],
        _buildingPaths = {
          for (final b in CampusMapLayout.buildings) b.id: b.path,
        },
        _buildingCenters = {
          for (final b in CampusMapLayout.buildings) b.id: b.center,
        },
        _numberPainters = {
          for (final b in CampusMapLayout.buildings)
            b.id: TextPainter(
              text: TextSpan(
                text: '${b.number}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              textDirection: TextDirection.ltr,
            )..layout(),
        };

  final ColorScheme colorScheme;
  final String? selectedBuildingId;
  final List<Offset> routePoints;

  /// Кэш геометрии: Path/TextPainter создаются один раз, а не каждый paint().
  final List<Path> _greenPaths;
  final List<Path> _roadPaths;
  final Map<String, Path> _buildingPaths;
  final Map<String, Offset> _buildingCenters;
  final Map<String, TextPainter> _numberPainters;

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
    for (final path in _greenPaths) {
      canvas
        ..drawPath(path, grassPaint)
        ..drawPath(path, grassOutline);
    }

    for (var i = 0; i < CampusMapLayout.roads.length; i++) {
      final road = CampusMapLayout.roads[i];
      final path = _roadPaths[i];
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

    _paintRoute(canvas);

    _paintFacilities(canvas);

    for (final building in CampusMapLayout.buildings) {
      _paintBuilding(
        canvas,
        building,
        _buildingPaths[building.id]!,
        _buildingCenters[building.id]!,
        _numberPainters[building.id]!,
      );
    }
    for (final building in CampusMapLayout.buildings) {
      final name = building.name;
      final anchor = building.labelAnchor;
      if (name != null && anchor != null) {
        _paintMapLabel(canvas, name, anchor, maxWidth: 190);
      }
    }
    _paintEntrances(canvas);
    canvas.restore();
  }

  static Path _buildRoadPath(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    return path;
  }

  void _paintRoute(Canvas canvas) {
    if (routePoints.length < 2) return;
    final path = _buildRoadPath(routePoints);
    canvas
      ..drawPath(
        path,
        Paint()
          ..color = colorScheme.surface.withValues(alpha: 0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 11
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      )
      ..drawPath(
        path,
        Paint()
          ..color = colorScheme.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    for (final point in [routePoints.first, routePoints.last]) {
      canvas
        ..drawCircle(point, 9, Paint()..color = colorScheme.surface)
        ..drawCircle(point, 6, Paint()..color = colorScheme.primary);
    }
  }

  void _paintEntrances(Canvas canvas) {
    for (final entrance in CampusMapLayout.entrances) {
      final selected =
          routePoints.isNotEmpty &&
          (routePoints.first == entrance.position ||
              routePoints.last == entrance.position);
      canvas
        ..drawCircle(
          entrance.position,
          selected ? 8 : 6,
          Paint()..color = colorScheme.surface,
        )
        ..drawCircle(
          entrance.position,
          selected ? 5 : 3.5,
          Paint()
            ..color = selected ? colorScheme.primary : colorScheme.tertiary,
        );
    }
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

  void _paintBuilding(
    Canvas canvas,
    CampusMapBuilding building,
    Path path,
    Offset markerCenter,
    TextPainter numberPainter,
  ) {
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
    // drawShadow — самая дорогая операция. В тёмной теме тени почти
    // не видно, пропускаем их полностью.
    final isDark = colorScheme.brightness == Brightness.dark;
    if (!isDark) {
      canvas.drawShadow(
        path.shift(const Offset(0, 3)),
        Colors.black.withValues(alpha: 0.28),
        selected ? 12 : 7,
        true,
      );
    }
    final roofBounds = path.getBounds();
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
      // Один каскад на здание: крыша, обводка, маркер и его ободок.
      ..drawPath(path, roofPaint)
      ..drawPath(
        path,
        Paint()
          ..color = selected
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.42)
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected ? 4 : 1.4,
      )
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
    numberPainter.paint(
      canvas,
      markerCenter - Offset(numberPainter.width / 2, numberPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _CampusMapPainter oldDelegate) {
    return oldDelegate.colorScheme != colorScheme ||
        oldDelegate.selectedBuildingId != selectedBuildingId ||
        oldDelegate.routePoints != routePoints;
  }
}
