import 'news_article.dart';

abstract interface class NewsRepository {
  /// Стрим, который отдаёт сначала кэш, затем свежие данные (если есть).
  Stream<List<NewsArticle>> watchList({
    int page = 1,
    bool forceRefresh = false,
  });

  Future<NewsArticleFull> getDetail(
    NewsArticle preview, {
    bool forceRefresh = false,
  });
}