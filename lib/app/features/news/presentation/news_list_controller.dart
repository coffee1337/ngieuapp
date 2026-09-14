import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ngieuapp/app/features/news/data/news_providers.dart';
import 'package:ngieuapp/app/features/news/domain/news_article.dart';

/// Стрим списка новостей с поддержкой принудительного обновления.
final newsListProvider = StreamProvider.autoDispose<List<NewsArticle>>((ref) {
  return ref.watch(newsRepositoryProvider).watchList();
});

/// Метод для принудительного обновления новостей
Future<void> refreshNews(WidgetRef ref) async {
  // Capture the provider owner before awaiting: the screen may be disposed.
  final context = ref.context;
  final container = ProviderScope.containerOf(context, listen: false);
  try {
    await ref.read(newsRepositoryProvider).watchList(forceRefresh: true).last;
    if (context.mounted) container.invalidate(newsListProvider);
  } on Object {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось обновить новости')),
      );
    }
  }
}

/// Метод для принудительного обновления деталей конкретной новости
Future<void> refreshNewsDetail(WidgetRef ref, NewsArticle preview) async {
  final context = ref.context;
  final container = ProviderScope.containerOf(context, listen: false);
  try {
    await ref
        .read(newsRepositoryProvider)
        .getDetail(preview, forceRefresh: true);
    if (context.mounted) container.invalidate(newsDetailProvider(preview));
  } on Object {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось обновить новость')),
      );
    }
  }
}

/// Деталь новости по preview-объекту.
final newsDetailProvider = FutureProvider.autoDispose
    .family<NewsArticleFull, NewsArticle>((ref, preview) {
      return ref.watch(newsRepositoryProvider).getDetail(preview);
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
