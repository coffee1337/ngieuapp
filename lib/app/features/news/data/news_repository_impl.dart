import '../domain/news_article.dart';
import '../domain/news_repository.dart';
import 'news_api_datasource.dart';
import 'news_cache_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl(this._api, this._cache);
  final NewsApiDataSource _api;
  final NewsCacheDataSource _cache;

  static const _staleAfter = Duration(hours: 1);

  /// Стратегия: cache-first, fresh-in-background если истёк TTL.
  @override
  Stream<List<NewsArticle>> watchList({int page = 1, bool forceRefresh = false}) async* {
    final cached = await _cache.loadList(page);
    if (cached.items.isNotEmpty) yield cached.items;

    final isStale = cached.updatedAt == null ||
        DateTime.now().difference(cached.updatedAt!) > _staleAfter;
    if (forceRefresh || isStale || cached.items.isEmpty) {
      try {
        final fresh = await _api.fetchPage(page);
        if (fresh.isNotEmpty) {
          await _cache.saveList(page, fresh);
          yield fresh;
        }
      } catch (e) {
        // Если кэш есть — уже отдали. Иначе — пробрасываем.
        if (cached.items.isEmpty) rethrow;
      }
    }
  }

  @override
  Future<NewsArticleFull> getDetail(NewsArticle preview,
      {bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _cache.loadDetail(preview.id);
      if (cached != null) return cached;
    }
    final fresh = await _api.fetchDetail(preview);
    await _cache.saveDetail(fresh);
    return fresh;
  }
}