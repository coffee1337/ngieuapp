import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/news_providers.dart';
import '../domain/news_article.dart';

part 'news_list_controller.g.dart';

@riverpod
class NewsListController extends _$NewsListController {
  @override
  Stream<List<NewsArticle>> build() {
    return ref.read(newsRepositoryProvider).watchList();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
Future<NewsArticleFull> newsDetail(NewsDetailRef ref, NewsArticle preview) {
  return ref.read(newsRepositoryProvider).getDetail(preview);
}

/// Вспомогательный: найти preview по id (для deep link по /news/detail/:id).
@riverpod
Future<NewsArticle?> newsPreviewById(NewsPreviewByIdRef ref, int id) async {
  final list = await ref.watch(newsListControllerProvider.future);
  for (final a in list) {
    if (a.id == id) return a;
  }
  return null;
}