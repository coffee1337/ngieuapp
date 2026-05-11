import 'package:dio/dio.dart';
import 'package:ngieuapp/app/features/news/data/news_parser.dart';
import 'package:ngieuapp/app/features/news/domain/news_article.dart';

class NewsApiDataSource {
  NewsApiDataSource(this._dio, this._parser);
  final Dio _dio;
  final NewsParser _parser;

  Future<List<NewsArticle>> fetchPage(
    int page, {
    CancelToken? cancelToken,
  }) async {
    final path = page == 1 ? 'ngieu-news/' : 'ngieu-news/page/$page/';
    final response = await _dio.get<String>(path, cancelToken: cancelToken);
    return _parser.parseList(response.data ?? '');
  }

  Future<NewsArticleFull> fetchDetail(
    NewsArticle preview, {
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<String>(
      preview.url,
      cancelToken: cancelToken,
    );
    return _parser.parseDetail(preview, response.data ?? '');
  }
}
