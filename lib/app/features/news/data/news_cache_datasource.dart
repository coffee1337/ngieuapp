import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/news_article.dart';

class NewsCacheDataSource {
  static const _listBox = 'news_list';
  static const _detailBox = 'news_detail';
  static const _metaBox = 'news_meta';

  Future<void> saveList(int page, List<NewsArticle> items) async {
    final box = await Hive.openBox<String>(_listBox);
    await box.put('page_$page', jsonEncode(items.map((e) => e.toJson()).toList()));
    final meta = await Hive.openBox<int>(_metaBox);
    await meta.put('page_${page}_at', DateTime.now().millisecondsSinceEpoch);
  }

  Future<({List<NewsArticle> items, DateTime? updatedAt})> loadList(int page) async {
    final box = await Hive.openBox<String>(_listBox);
    final raw = box.get('page_$page');
    if (raw == null) return (items: <NewsArticle>[], updatedAt: null);
    final list = (jsonDecode(raw) as List)
        .map((e) => NewsArticle.fromJson(e as Map<String, dynamic>))
        .toList();
    final meta = await Hive.openBox<int>(_metaBox);
    final ts = meta.get('page_${page}_at');
    return (
      items: list,
      updatedAt: ts == null ? null : DateTime.fromMillisecondsSinceEpoch(ts),
    );
  }

  Future<void> saveDetail(NewsArticleFull detail) async {
    final box = await Hive.openBox<String>(_detailBox);
    await box.put(detail.preview.id.toString(), jsonEncode({
      'preview': detail.preview.toJson(),
      'html': detail.contentHtml,
      'gallery': detail.gallery,
    }));
  }

  Future<NewsArticleFull?> loadDetail(int id) async {
    final box = await Hive.openBox<String>(_detailBox);
    final raw = box.get(id.toString());
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return NewsArticleFull(
      preview: NewsArticle.fromJson(map['preview'] as Map<String, dynamic>),
      contentHtml: map['html'] as String,
      gallery: (map['gallery'] as List).cast<String>(),
    );
  }
}