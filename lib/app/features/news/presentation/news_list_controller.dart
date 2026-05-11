import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ngieuapp/app/features/news/data/news_providers.dart';
import 'package:ngieuapp/app/features/news/domain/news_article.dart';

/// Состояние принудительного обновления новостей
final forceRefreshProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Стрим списка новостей с поддержкой принудительного обновления.
final newsListProvider = StreamProvider.autoDispose<List<NewsArticle>>((ref) {
  final forceRefresh = ref.watch(forceRefreshProvider);
  return ref
      .watch(newsRepositoryProvider)
      .watchList(forceRefresh: forceRefresh);
});

/// Метод для принудительного обновления новостей
Future<void> refreshNews(WidgetRef ref) async {
  ref.read(forceRefreshProvider.notifier).state = true;
  ref.invalidate(newsListProvider);
}

/// Метод для принудительного обновления деталей конкретной новости
Future<void> refreshNewsDetail(WidgetRef ref, NewsArticle preview) async {
  ref.read(forceRefreshProvider.notifier).state = true;
  ref.invalidate(newsDetailProvider(preview));
}

/// Деталь новости по preview-объекту.
final newsDetailProvider = FutureProvider.autoDispose
    .family<NewsArticleFull, NewsArticle>((ref, preview) {
      final forceRefresh = ref.watch(forceRefreshProvider);
      return ref
          .watch(newsRepositoryProvider)
          .getDetail(preview, forceRefresh: forceRefresh);
    });

/// Находим preview по id (для deep-link /news/detail/:id).
final newsPreviewByIdProvider = FutureProvider.autoDispose
    .family<NewsArticle?, int>((ref, id) async {
      final list = await ref.watch(newsListProvider.future);
      for (final a in list) {
        if (a.id == id) return a;
      }
      return null;
    });
