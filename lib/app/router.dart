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

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/news',
    routes: [
      ShellRoute(
        builder: (context, state, child) => _RootShell(child: child),
        routes: [
          GoRoute(
            path: '/news',
            builder: (_, __) => const NewsListScreen(),
            routes: [
              GoRoute(
                path: 'detail/:id',
                builder: (ctx, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return NewsDetailScreen(articleId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/schedule',
            builder: (_, __) => const ActorPickerScreen(),
            routes: [
              GoRoute(
                path: 'free-rooms',
                builder: (_, __) => const FreeRoomsScreen(),
              ),
              GoRoute(
                path: ':actorId',
                builder: (ctx, state) => WeekScheduleScreen(
                  actorId: state.pathParameters['actorId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'settings',
                builder: (_, __) => const SettingsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/learning',
            builder: (_, __) => const LearningWebViewScreen(),
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