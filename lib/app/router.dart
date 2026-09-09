import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ngieuapp/app/features/learning/presentation/learning_webview_screen.dart';
import 'package:ngieuapp/app/features/news/presentation/news_detail_screen.dart';
import 'package:ngieuapp/app/features/news/presentation/news_list_screen.dart';
import 'package:ngieuapp/app/features/profile/presentation/profile_screen.dart';
import 'package:ngieuapp/app/features/schedule/domain/favorite_actor.dart';
import 'package:ngieuapp/app/features/schedule/presentation/actor_picker_screen.dart';
import 'package:ngieuapp/app/features/schedule/presentation/free_rooms_screen.dart';
import 'package:ngieuapp/app/features/schedule/presentation/schedule_home_screen.dart';
import 'package:ngieuapp/app/features/schedule/presentation/schedule_search_screen.dart';
import 'package:ngieuapp/app/features/schedule/presentation/week_schedule_screen.dart';
import 'package:ngieuapp/app/features/settings/presentation/settings_screen.dart';
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
            pageBuilder: (_, __) => _page(const ScheduleHomeScreen()),
            routes: [
              GoRoute(
                path: 'pick',
                pageBuilder: (_, __) => _page(const ActorPickerScreen()),
              ),
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
                pageBuilder: (ctx, state) {
                  final extra = state.extra;
                  return _page(
                    WeekScheduleScreen(
                      actorId: state.pathParameters['actorId']!,
                      initialActor: extra is FavoriteActor ? extra : null,
                    ),
                  );
                },
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
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final matchedIndex = _tabs.indexWhere(
      (tab) => location.startsWith(tab.path),
    );
    final index = matchedIndex < 0 ? 0 : matchedIndex;
    final theme = Theme.of(context);
    final wide =
        MediaQuery.sizeOf(context).width >= AppLayout.navigationRailBreakpoint;
    final content = Column(
      children: [
        const OfflineBanner(),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppLayout.contentMaxWidth,
              ),
              child: child,
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      body: wide
          ? Row(
              children: [
                SafeArea(
                  right: false,
                  child: NavigationRail(
                    selectedIndex: index,
                    onDestinationSelected: (i) => context.go(_tabs[i].path),
                    labelType: MediaQuery.sizeOf(context).height < 600
                        ? NavigationRailLabelType.none
                        : NavigationRailLabelType.all,
                    minWidth: 112,
                    groupAlignment: -0.65,
                    leading: MediaQuery.sizeOf(context).height < 600
                        ? null
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'НГИЭУ',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                    destinations: [
                      for (final tab in _tabs)
                        NavigationRailDestination(
                          icon: Icon(tab.icon),
                          selectedIcon: Icon(tab.activeIcon),
                          label: Text(tab.label),
                        ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: content),
              ],
            )
          : content,
      bottomNavigationBar: wide
          ? null
          : DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
              child: NavigationBar(
                selectedIndex: index,
                onDestinationSelected: (i) => context.go(_tabs[i].path),
                height: AppSizes.navBarHeight,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: [
                  for (final tab in _tabs)
                    NavigationDestination(
                      icon: Icon(tab.icon),
                      selectedIcon: Icon(tab.activeIcon),
                      label: tab.label,
                    ),
                ],
              ),
            ),
    );
  }
}
