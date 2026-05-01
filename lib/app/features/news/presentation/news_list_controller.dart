import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/news_providers.dart';
import '../domain/news_article.dart';

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
  final notifier = ref.read(forceRefreshProvider.notifier);
  notifier.state = true;

  // Даем время стриму отреагировать на изменение состояния
  await Future.delayed(const Duration(milliseconds: 50));

  // Инвалидируем провайдер новостей, чтобы гарантировать перезагрузку
  ref.invalidate(newsListProvider);

  // Ждем немного чтобы стрим начал обновляться
  await Future.delayed(const Duration(milliseconds: 100));

  // Сбрасываем флаг force refresh
  notifier.state = false;
}

/// Метод для принудительного обновления деталей конкретной новости
Future<void> refreshNewsDetail(WidgetRef ref, NewsArticle preview) async {
  final notifier = ref.read(forceRefreshProvider.notifier);
  notifier.state = true;

  // Инвалидируем провайдер деталей для конкретной новости
  ref.invalidate(newsDetailProvider(preview));

  // Даем время для обновления
  await Future.delayed(const Duration(milliseconds: 100));

  notifier.state = false;
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
