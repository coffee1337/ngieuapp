import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ngieuapp/app/core/network/api_exception.dart';
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
    try {
      final response = await _dio.get<String>(path, cancelToken: cancelToken);
      // Парсинг HTML (~100-300мс) — в isolate, чтобы не фризить скролл.
      return compute(_parseList, (response.data ?? '', _parser.baseUrl));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<NewsArticleFull> fetchDetail(
    NewsArticle preview, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<String>(
        preview.url,
        cancelToken: cancelToken,
      );
      return compute(_parseDetail, (
        response.data ?? '',
        preview,
        _parser.baseUrl,
      ));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

/// Top-level функции для compute(): замыкания и методы классов нельзя.
List<NewsArticle> _parseList((String, String) args) {
  final (html, baseUrl) = args;
  return NewsParser(baseUrl: baseUrl).parseList(html);
}

NewsArticleFull _parseDetail((String, NewsArticle, String) args) {
  final (html, preview, baseUrl) = args;
  return NewsParser(baseUrl: baseUrl).parseDetail(preview, html);
}
