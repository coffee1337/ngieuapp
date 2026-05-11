import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ngieuapp/app/features/learning/presentation/learning_webview_screen.dart';
import 'package:ngieuapp/app/features/news/presentation/news_detail_screen.dart';
import 'package:ngieuapp/app/features/news/presentation/news_list_screen.dart';
import 'package:ngieuapp/app/features/profile/presentation/profile_screen.dart';
import 'package:ngieuapp/app/features/schedule/presentation/actor_picker_screen.dart';
import 'package:ngieuapp/app/features/schedule/presentation/free_rooms_screen.dart';
import 'package:ngieuapp/app/features/schedule/presentation/schedule_search_screen.dart';
import 'package:ngieuapp/app/features/schedule/presentation/week_schedule_screen.dart';
import 'package:ngieuapp/app/features/settings/presentation/settings_screen.dart';
import 'package:ngieuapp/app/shared/widgets/app_gradient_bar.dart';
import 'package:ngieuapp/app/shared/widgets/offline_banner.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

CustomTransitionPage<T> _page<T>(Widget child) => CustomTransitionPage<T>(
  child: child,
  transitionDuration: AppDurations.normal,
  reverseTransitionDuration: AppDurations.normal,
  transitionsBuilder: (_, anim, __, child) {
    final curved = CurvedAnimation(
      parent: anim,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInToLinear,
    );
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: anim,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.03),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  },
);

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/news',
    routes: [
      ShellRoute(
        builder: (context, state, child) => _RootShell(child: child),
        routes: [
          GoRoute(
            path: '/news',
            pageBuilder: (_, __) => _page(const NewsListScreen()),
            routes: [
              GoRoute(
                path: 'detail/:id',
                redirect: (context, state) {
                  final raw = state.pathParameters['id'];
                  if (raw == null || int.tryParse(raw) == null) {
                    return '/news';
                  }
                  return null;
                },
                pageBuilder: (ctx, state) {
                  final id =
                      int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                  return _page(NewsDetailScreen(articleId: id));
                },
              ),
            ],
          ),
          GoRoute(
            path: '/schedule',
            pageBuilder: (_, __) => _page(const ActorPickerScreen()),
            routes: [
              GoRoute(
                path: 'free-rooms',
                pageBuilder: (_, __) => _page(const FreeRoomsScreen()),
              ),
              GoRoute(
                path: 'search',
                pageBuilder: (_, __) => _page(const ScheduleSearchScreen()),
              ),
              GoRoute(
                path: ':actorId',
                pageBuilder: (ctx, state) => _page(
                  WeekScheduleScreen(actorId: state.pathParameters['actorId']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (_, __) => _page(const ProfileScreen()),
            routes: [
              GoRoute(
                path: 'settings',
                pageBuilder: (_, __) => _page(const SettingsScreen()),
              ),
            ],
          ),
          GoRoute(
            path: '/learning',
            pageBuilder: (_, __) => _page(const LearningWebViewScreen()),
          ),
        ],
      ),
    ],
  );
});

class _RootShell extends StatefulWidget {
  const _RootShell({required this.child});
  final Widget child;

  @override
  State<_RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<_RootShell> with TickerProviderStateMixin {
  late final AnimationController _animController;
  bool _initialized = false;

  static const _tabs = [
    (
      path: '/news',
      icon: Icons.article_outlined,
      activeIcon: Icons.article_rounded,
      label: 'Новости',
    ),
    (
      path: '/schedule',
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today_rounded,
      label: 'Расписание',
    ),
    (
      path: '/profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person_rounded,
      label: 'Профиль',
    ),
    (
      path: '/learning',
      icon: Icons.school_outlined,
      activeIcon: Icons.school_rounded,
      label: 'Обучение',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppDurations.fast,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  int _indexFromLocation(String loc) {
    for (var i = 0; i < _tabs.length; i++) {
      if (loc.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final idx = _indexFromLocation(location);
    final theme = Theme.of(context);

    if (!_initialized) {
      _initialized = true;
      _animController.value = 1.0;
    } else {
      _animController.forward(from: 0);
    }

    return Scaffold(
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: FadeTransition(
              opacity: _animController,
              child: widget.child,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppGradientBar(height: 1),
          NavigationBar(
            selectedIndex: idx,
            onDestinationSelected: (i) => context.go(_tabs[i].path),
            height: AppSizes.navBarHeight,
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            indicatorColor: theme.colorScheme.primaryContainer.withValues(
              alpha: 0.3,
            ),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              for (final t in _tabs)
                NavigationDestination(
                  icon: Icon(t.icon, size: AppSizes.iconLg),
                  selectedIcon: Icon(t.activeIcon, size: AppSizes.iconLg),
                  label: t.label,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
