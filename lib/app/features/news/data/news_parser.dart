import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import '../domain/news_article.dart';

/// Чистый парсер, не знает про сеть — легко тестировать.
class NewsParser {
  static final _idPattern = RegExp(r'/ngieu-news/(\d+)/');

  static const _monthMap = {
    'янв': 1,
    'фев': 2,
    'мар': 3,
    'апр': 4,
    'май': 5,
    'мая': 5,
    'июн': 6,
    'июл': 7,
    'авг': 8,
    'сен': 9,
    'окт': 10,
    'ноя': 11,
    'дек': 12,
  };

  List<NewsArticle> parseList(String html) {
    final doc = parse(html);
    // Каждая новость — <article> или <div class="post-XXXX">
    final articles = doc.querySelectorAll('article, div[id^="post-"]');
    final result = <NewsArticle>[];
    final seen = <int>{};

    for (final el in articles) {
      final article = _parseCard(el);
      if (article != null && seen.add(article.id)) {
        result.add(article);
      }
    }
    return result;
  }

  NewsArticle? _parseCard(Element el) {
    // 1. Ссылка на новость: предпочитаем из h2, fallback на любую подходящую
    final titleLink =
        el.querySelector('h2 a[href*="/ngieu-news/"]') ??
        el.querySelector('a[href*="/ngieu-news/"][title]');
    if (titleLink == null) return null;

    final href = titleLink.attributes['href'] ?? '';
    final idMatch = _idPattern.firstMatch(href);
    if (idMatch == null) return null;
    final id = int.parse(idMatch.group(1)!);

    final title = titleLink.text.trim();
    if (title.isEmpty) return null;

    // 2. Картинка
    final img = el.querySelector('img');
    final imageUrl = img?.attributes['src'];

    // 3. Excerpt — первый <p> в карточке
    final excerpt = el.querySelector('p')?.text.trim() ?? '';

    // 4. Дата (два коротких текста: "22", "Апр")
    final date = _extractDate(el);

    // 5. Автор
    final author = el.querySelector('a[href*="/author/"]')?.text.trim();

    return NewsArticle(
      id: id,
      title: title,
      url: href.startsWith('http') ? href : 'https://ngieu.ru$href',
      excerpt: excerpt,
      imageUrl: imageUrl,
      publishedAt: date,
      author: author,
    );
  }

  DateTime? _extractDate(Element el) {
    // На WP-темах день и месяц — короткие текстовые узлы перед заголовком
    final texts = el.nodes
        .expand((n) => _collectText(n))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    int? day;
    int? month;
    for (var i = 0; i < texts.length; i++) {
      final t = texts[i].toLowerCase();
      if (day == null) {
        final n = int.tryParse(t);
        if (n != null && n >= 1 && n <= 31) day = n;
      } else if (month == null) {
        final key = t.length >= 3 ? t.substring(0, 3) : t;
        if (_monthMap.containsKey(key)) {
          month = _monthMap[key];
          break;
        }
      }
    }
    if (day == null || month == null) return null;

    final now = DateTime.now();
    // Если месяц > текущего — вероятно, прошлый год
    final year = month <= now.month ? now.year : now.year - 1;
    return DateTime(year, month, day);
  }

  Iterable<String> _collectText(Node n) sync* {
    if (n is Text) yield n.text;
    for (final c in n.nodes) {
      yield* _collectText(c);
    }
  }

  /// Детальная страница
  NewsArticleFull parseDetail(NewsArticle preview, String html) {
    final doc = parse(html);
    // На WP обычно контент в div.entry-content или article .post-content
    final contentEl =
        doc.querySelector('.entry-content') ??
        doc.querySelector('article .post-content') ??
        doc.querySelector('article');

    final gallery = <String>[];
    if (contentEl != null) {
      for (final img in contentEl.querySelectorAll('img')) {
        final src = img.attributes['src'];
        if (src != null && src.isNotEmpty) gallery.add(src);
      }
    }

    // Убираем скрипты и комментарии
    contentEl
        ?.querySelectorAll('script, style, .sharedaddy, #comments')
        .forEach((e) => e.remove());

    return NewsArticleFull(
      preview: preview,
      contentHtml: contentEl?.innerHtml ?? '<p>Не удалось загрузить текст</p>',
      gallery: gallery,
    );
  }
}
