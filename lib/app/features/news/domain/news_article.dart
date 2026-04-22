import 'package:freezed_annotation/freezed_annotation.dart';
part 'news_article.freezed.dart';
part 'news_article.g.dart';

@freezed
class NewsArticle with _$NewsArticle {
  const factory NewsArticle({
    required int id,              // 49607
    required String title,
    required String url,
    required String excerpt,
    String? imageUrl,
    DateTime? publishedAt,        // локальная дата (день+месяц, год из сайта не видно)
    String? author,
  }) = _NewsArticle;

  factory NewsArticle.fromJson(Map<String, dynamic> json) =>
      _$NewsArticleFromJson(json);
}

@freezed
class NewsArticleFull with _$NewsArticleFull {
  const factory NewsArticleFull({
    required NewsArticle preview,
    required String contentHtml,   // очищенный HTML для flutter_html
    required List<String> gallery,
  }) = _NewsArticleFull;
}