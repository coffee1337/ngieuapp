import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ngieuapp/app/features/campus/presentation/campus_directions_screen.dart';
import 'package:ngieuapp/app/features/campus/presentation/campus_map_screen.dart';
import 'package:ngieuapp/app/features/learning/presentation/learning_webview_screen.dart';
import 'package:ngieuapp/app/features/news/presentation/news_detail_screen.dart';
import 'package:ngieuapp/app/features/news/presentation/news_list_screen.dart';
import 'package:ngieuapp/app/features/notifications/notifications_service.dart';
import 'package:ngieuapp/app/features/profile/presentation/profile_screen.dart';
import 'package:ngieuapp/app/features/schedule/domain/favorite_actor.dart';
import 'package:ngieuapp/app/features/schedule/presentation/actor_picker_screen.dart';
import 'package:ngieuapp/app/features/schedule/presentation/free_rooms_screen.dart';
import 'package:ngieuapp/app/features/schedule/presentation/schedule_home_screen.dart';
import 'package:ngieuapp/app/features/schedule/presentation/schedule_search_screen.dart';
import 'package:ngieuapp/app/features/schedule/presentation/week_schedule_screen.dart';
import 'package:ngieuapp/app/features/settings/data/navigation_settings_providers.dart';
import 'package:ngieuapp/app/features/settings/domain/app_navigation_settings.dart';
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
    initialLocation: '/',
    refreshListenable: NotificationsService.instance.selectedRoute,
    redirect: (_, state) {
      final route = NotificationsService.instance.takeSelectedRoute();
      if (route != null && route != state.uri.path) return route;
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) async {
          final settings = await ref
              .read(navigationSettingsRepositoryProvider)
              .load();
          return settings.defaultTab.path;
        },
      ),
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
            path: '/campus',
            pageBuilder: (_, state) => _page(
              CampusMapScreen(initialRoom: state.uri.queryParameters['room']),
            ),
            routes: [
              GoRoute(
                path: 'directions',
                pageBuilder: (_, __) => _page(const CampusDirectionsScreen()),
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

class _RootShell extends ConsumerWidget {
  const _RootShell({required this.child});
  final Widget child;

  static const _tabs = [
    (
      id: AppTab.news,
      path: '/news',
      icon: Icons.article_outlined,
      activeIcon: Icons.article_rounded,
      label: 'Новости',
    ),
    (
      id: AppTab.schedule,
      path: '/schedule',
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today_rounded,
      label: 'Расписание',
    ),
    (
      id: AppTab.campus,
      path: '/campus',
      icon: Icons.map_outlined,
      activeIcon: Icons.map_rounded,
      label: 'Карта',
    ),
    (
      id: AppTab.profile,
      path: '/profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person_rounded,
      label: 'Профиль',
    ),
    (
      id: AppTab.learning,
      path: '/learning',
      icon: Icons.school_outlined,
      activeIcon: Icons.school_rounded,
      label: 'Обучение',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(navigationSettingsProvider);
    final tabs = _tabs
        .where((tab) => navigation.visibleTabs.contains(tab.id))
        .toList(growable: false);
    final location = GoRouterState.of(context).uri.path;
    final matchedIndex = tabs.indexWhere(
      (tab) => location.startsWith(tab.path),
    );
    final index = matchedIndex < 0 ? tabs.length : matchedIndex;
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
                    onDestinationSelected: (i) {
                      if (i == tabs.length) {
                        _showMoreMenu(context, navigation);
                      } else {
                        context.go(tabs[i].path);
                      }
                    },
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
                      for (final tab in tabs)
                        NavigationRailDestination(
                          icon: Icon(tab.icon),
                          selectedIcon: Icon(tab.activeIcon),
                          label: Text(tab.label),
                        ),
                      const NavigationRailDestination(
                        icon: Icon(Icons.more_horiz_rounded),
                        selectedIcon: Icon(Icons.more_rounded),
                        label: Text('Ещё'),
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
                onDestinationSelected: (i) {
                  if (i == tabs.length) {
                    _showMoreMenu(context, navigation);
                  } else {
                    context.go(tabs[i].path);
                  }
                },
                height: AppSizes.navBarHeight,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: [
                  for (final tab in tabs)
                    NavigationDestination(
                      icon: Icon(tab.icon),
                      selectedIcon: Icon(tab.activeIcon),
                      label: tab.label,
                    ),
                  const NavigationDestination(
                    icon: Icon(Icons.more_horiz_rounded),
                    selectedIcon: Icon(Icons.more_rounded),
                    label: 'Ещё',
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _showMoreMenu(
    BuildContext context,
    AppNavigationSettings navigation,
  ) async {
    final hidden = _tabs
        .where((tab) => !navigation.visibleTabs.contains(tab.id))
        .toList(growable: false);
    final path = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hidden.isNotEmpty)
              for (final tab in hidden)
                ListTile(
                  leading: Icon(tab.icon),
                  title: Text(tab.label),
                  onTap: () => Navigator.pop(context, tab.path),
                ),
            ListTile(
              leading: const Icon(Icons.tune_rounded),
              title: const Text('Настройки'),
              subtitle: const Text('Вкладки, оформление и уведомления'),
              onTap: () => Navigator.pop(context, '/profile/settings'),
            ),
          ],
        ),
      ),
    );
    if (path != null && context.mounted) context.go(path);
  }
}
