import 'package:ngieuapp/app/features/news/data/news_api_datasource.dart';
import 'package:ngieuapp/app/features/news/data/news_cache_datasource.dart';
import 'package:ngieuapp/app/features/news/domain/news_article.dart';
import 'package:ngieuapp/app/features/news/domain/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl(this._api, this._cache);
  final NewsApiDataSource _api;
  final NewsCacheDataSource _cache;

  static const _staleAfter = Duration(hours: 1);

  /// Стратегия: cache-first, fresh-in-background если истёк TTL.
  @override
  Stream<List<NewsArticle>> watchList({
    int page = 1,
    bool forceRefresh = false,
  }) async* {
    final cached = await _cache.loadList(page);

    final isStale =
        cached.updatedAt == null ||
        DateTime.now().difference(cached.updatedAt!) > _staleAfter;

    // Если не принудительное обновление и есть кэш, показываем его сразу
    if (!forceRefresh && cached.items.isNotEmpty) {
      yield cached.items;
    }

    // Загружаем свежие данные если нужно
    if (forceRefresh || isStale || cached.items.isEmpty) {
      try {
        final fresh = await _api.fetchPage(page);
        if (fresh.isNotEmpty) {
          await _cache.saveList(page, fresh);
          yield fresh;
        } else if (!forceRefresh && cached.items.isNotEmpty) {
          // Если API вернул пустой список, но не forceRefresh, показываем кэш
          yield cached.items;
        } else if (forceRefresh && fresh.isEmpty) {
          // Если forceRefresh и API вернул пустой список, показываем пустой список
          yield fresh;
        }
      } catch (e) {
        // Если ошибка при загрузке
        if (cached.items.isNotEmpty && !forceRefresh) {
          // Показываем кэш только если не forceRefresh
          yield cached.items;
        } else if (forceRefresh) {
          // При forceRefresh и ошибке, пробрасываем ошибку
          rethrow;
        } else {
          // Если нет кэша и не forceRefresh, пробрасываем ошибку
          rethrow;
        }
      }
    }
  }

  @override
  Future<NewsArticleFull> getDetail(
    NewsArticle preview, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await _cache.loadDetail(preview.id);
      if (cached != null) return cached;
    }
    try {
      final fresh = await _api.fetchDetail(preview);
      await _cache.saveDetail(fresh);
      return fresh;
    } catch (e) {
      // При ошибке и forceRefresh, пробуем загрузить из кэша
      if (forceRefresh) {
        final cached = await _cache.loadDetail(preview.id);
        if (cached != null) return cached;
      }
      rethrow;
    }
  }
}
