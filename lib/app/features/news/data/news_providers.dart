import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/providers.dart';
import '../domain/news_repository.dart';
import 'news_api_datasource.dart';
import 'news_cache_datasource.dart';
import 'news_parser.dart';
import 'news_repository_impl.dart';

final newsParserProvider = Provider<NewsParser>((ref) {
  return NewsParser();
});

final newsApiDataSourceProvider = Provider<NewsApiDataSource>((ref) {
  return NewsApiDataSource(
    ref.watch(newsApiProvider),
    ref.watch(newsParserProvider),
  );
});

final newsCacheDataSourceProvider = Provider<NewsCacheDataSource>((ref) {
  return NewsCacheDataSource();
});

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl(
    ref.watch(newsApiDataSourceProvider),
    ref.watch(newsCacheDataSourceProvider),
  );
});