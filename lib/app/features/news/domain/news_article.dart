import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_article.freezed.dart';
part 'news_article.g.dart';

@freezed
abstract class NewsArticle with _$NewsArticle {
  const factory NewsArticle({
    required int id,
    required String title,
    required String url,
    required String excerpt,
    String? imageUrl,
    DateTime? publishedAt,
    String? author,
  }) = _NewsArticle;

  factory NewsArticle.fromJson(Map<String, dynamic> json) =>
      _$NewsArticleFromJson(json);
}

@freezed
abstract class NewsArticleFull with _$NewsArticleFull {
  const factory NewsArticleFull({
    required NewsArticle preview,
    required String contentHtml,
    required List<String> gallery,
  }) = _NewsArticleFull;
}
