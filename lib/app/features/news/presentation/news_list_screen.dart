import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_gradient_bar.dart';
import '../../../shared/widgets/empty_view.dart';
import '../../../shared/widgets/error_view.dart';
import 'news_list_controller.dart';
import 'widgets/news_card.dart';

class NewsListScreen extends ConsumerWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(newsListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новости НГИЭУ'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: AppGradientBar(),
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.read(newsListControllerProvider.notifier).refresh(),
        ),
        data: (articles) {
          if (articles.isEmpty) {
            return const EmptyView(
              text: 'Пока нет новостей',
              icon: Icons.article_outlined,
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(newsListControllerProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: articles.length,
              itemBuilder: (_, i) {
                final a = articles[i];
                return NewsCard(
                  article: a,
                  onTap: () => context.push('/news/detail/${a.id}'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}