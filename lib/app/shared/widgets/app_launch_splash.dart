import 'package:flutter/material.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class AppLaunchSplash extends StatefulWidget {
  const AppLaunchSplash({required this.child, super.key});

  final Widget child;

  @override
  State<AppLaunchSplash> createState() => _AppLaunchSplashState();
}

class _AppLaunchSplashState extends State<AppLaunchSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 1750),
          )
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && mounted) {
              setState(() => _finished = true);
            }
          })
          ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return widget.child;
    final scheme = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) {
      return widget.child;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final fadeOut = CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.76, 1, curve: Curves.easeInCubic),
              ).value;
              final logoEntrance = CurvedAnimation(
                parent: _controller,
                curve: const Interval(0, 0.38, curve: Curves.easeOutBack),
              ).value;
              final titleEntrance = CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.2, 0.55, curve: Curves.easeOutCubic),
              ).value;
              final progress = CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.18, 0.74, curve: Curves.easeInOut),
              ).value;

              return Opacity(
                opacity: 1 - fadeOut,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        scheme.primary,
                        Color.lerp(scheme.primary, Colors.black, 0.24)!,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.section),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.scale(
                              scale: 0.72 + logoEntrance * 0.28,
                              child: Opacity(
                                opacity: logoEntrance
                                    .clamp(0.0, 1.0)
                                    .toDouble(),
                                child: const _LaunchMark(),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            Transform.translate(
                              offset: Offset(0, 14 * (1 - titleEntrance)),
                              child: Opacity(
                                opacity: titleEntrance
                                    .clamp(0.0, 1.0)
                                    .toDouble(),
                                child: Column(
                                  children: [
                                    Text(
                                      'НГИЭУ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            color: scheme.onPrimary,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 3,
                                          ),
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      'Расписание всегда под рукой',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: scheme.onPrimary.withValues(
                                              alpha: 0.78,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.section),
                            SizedBox(
                              width: 148,
                              height: 3,
                              child: ClipRRect(
                                borderRadius: AppRadius.pillBr,
                                child: ColoredBox(
                                  color: scheme.onPrimary.withValues(
                                    alpha: 0.2,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FractionallySizedBox(
                                      widthFactor: progress
                                          .clamp(0.02, 1.0)
                                          .toDouble(),
                                      child: ColoredBox(
                                        color: scheme.onPrimary,
                                        child: const SizedBox.expand(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LaunchMark extends StatelessWidget {
  const _LaunchMark();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        color: scheme.onPrimary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.calendar_month_rounded, size: 58, color: scheme.primary),
          Positioned(
            right: 16,
            bottom: 17,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: scheme.tertiary,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.onPrimary, width: 3),
              ),
              child: Icon(
                Icons.school_rounded,
                size: 15,
                color: scheme.onTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
