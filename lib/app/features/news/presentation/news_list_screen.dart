import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngieuapp/app/features/news/presentation/news_list_controller.dart';
import 'package:ngieuapp/app/features/news/presentation/widgets/news_card.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';
import 'package:ngieuapp/app/shared/widgets/empty_view.dart';
import 'package:ngieuapp/app/shared/widgets/error_view.dart';
import 'package:ngieuapp/app/shared/widgets/motion_reveal.dart';
import 'package:ngieuapp/app/shared/widgets/skeleton.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class NewsListScreen extends ConsumerWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(newsListProvider);
    final showImages = ref.watch(
      appSettingsProvider.select((s) => s.showNewsImages),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('НГИЭУ')),
      body: state.when(
        loading: () => const NewsCardSkeleton(),
        error: (error, _) =>
            ErrorView(error: error, onRetry: () => ref.refresh(newsListProvider)),
        data: (articles) {
          if (articles.isEmpty) {
            return const EmptyView(
              text: 'Пока нет новостей',
              icon: Icons.article_outlined,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(newsListProvider.future),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: articles.length + 1,
              itemBuilder: (_, i) {
                if (i == 0) {
                  final theme = Theme.of(context);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Жизнь университета',
                          style: theme.textTheme.headlineLarge,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Новости и события кампуса',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final a = articles[i - 1];
                // Анимация только для первых 6 карточек: иначе десятки
                // одновременных AnimationController просаживают скролл.
                if (i > 6) {
                  return NewsCard(
                    article: a,
                    featured: i == 1,
                    showImage: showImages,
                    onTap: () => context.push('/news/detail/${a.id}'),
                  );
                }
                return MotionReveal(
                  key: ValueKey(a.id),
                  order: i,
                  child: NewsCard(
                    article: a,
                    featured: i == 1,
                    showImage: showImages,
                    onTap: () => context.push('/news/detail/${a.id}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
