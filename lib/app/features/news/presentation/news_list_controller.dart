import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/news_providers.dart';
import '../domain/news_article.dart';

/// Стрим списка новостей.
final newsListProvider = StreamProvider.autoDispose<List<NewsArticle>>((ref) {
  return ref.watch(newsRepositoryProvider).watchList();
});

/// Деталь новости по preview-объекту.
final newsDetailProvider =
    FutureProvider.autoDispose.family<NewsArticleFull, NewsArticle>(
  (ref, preview) {
    return ref.watch(newsRepositoryProvider).getDetail(preview);
  },
);

/// Находим preview по id (для deep-link /news/detail/:id).
final newsPreviewByIdProvider =
    FutureProvider.autoDispose.family<NewsArticle?, int>((ref, id) async {
  final list = await ref.watch(newsListProvider.future);
  for (final a in list) {
    if (a.id == id) return a;
  }
  return null;
});