import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/learning/presentation/learning_webview_screen.dart';
import 'features/news/presentation/news_detail_screen.dart';
import 'features/news/presentation/news_list_screen.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'features/schedule/presentation/actor_picker_screen.dart';
import 'features/schedule/presentation/free_rooms_screen.dart';
import 'features/schedule/presentation/week_schedule_screen.dart';
import 'features/settings/presentation/settings_screen.dart';

/// Плавная кастомная анимация для push-переходов (детальные экраны).
CustomTransitionPage<T> _page<T>(Widget child) => CustomTransitionPage<T>(
      child: child,
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (_, anim, __, child) {
        final curved = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeIn,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
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
                pageBuilder: (ctx, state) {
                  final id = int.parse(state.pathParameters['id']!);
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
                path: ':actorId',
                pageBuilder: (ctx, state) => _page(
                  WeekScheduleScreen(
                    actorId: state.pathParameters['actorId']!,
                  ),
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

class _RootShell extends StatelessWidget {
  const _RootShell({required this.child});
  final Widget child;

  static const _tabs = [
    (path: '/news', icon: Icons.article_outlined, label: 'Новости'),
    (path: '/schedule', icon: Icons.calendar_today_outlined, label: 'Расписание'),
    (path: '/profile', icon: Icons.person_outline, label: 'Профиль'),
    (path: '/learning', icon: Icons.school_outlined, label: 'Обучение'),
  ];

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
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: [
          for (final t in _tabs)
            NavigationDestination(icon: Icon(t.icon), label: t.label),
        ],
      ),
    );
  }
}