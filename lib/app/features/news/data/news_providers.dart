import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/providers.dart';
import '../domain/news_repository.dart';
import 'news_api_datasource.dart';
import 'news_cache_datasource.dart';
import 'news_parser.dart';
import 'news_repository_impl.dart';

part 'news_providers.g.dart';

@Riverpod(keepAlive: true)
NewsParser newsParser(NewsParserRef ref) => NewsParser();

@Riverpod(keepAlive: true)
NewsApiDataSource newsApiDataSource(NewsApiDataSourceRef ref) {
  return NewsApiDataSource(ref.watch(newsApiProvider), ref.watch(newsParserProvider));
}

@Riverpod(keepAlive: true)
NewsCacheDataSource newsCacheDataSource(NewsCacheDataSourceRef ref) {
  return NewsCacheDataSource();
}

@Riverpod(keepAlive: true)
NewsRepository newsRepository(NewsRepositoryRef ref) {
  return NewsRepositoryImpl(
    ref.watch(newsApiDataSourceProvider),
    ref.watch(newsCacheDataSourceProvider),
  );
}