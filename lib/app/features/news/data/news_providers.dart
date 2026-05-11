import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/core/network/providers.dart';
import 'package:ngieuapp/app/features/news/data/news_api_datasource.dart';
import 'package:ngieuapp/app/features/news/data/news_cache_datasource.dart';
import 'package:ngieuapp/app/features/news/data/news_parser.dart';
import 'package:ngieuapp/app/features/news/data/news_repository_impl.dart';
import 'package:ngieuapp/app/features/news/domain/news_repository.dart';

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
