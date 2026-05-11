import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/news/data/news_parser.dart';
import 'package:ngieuapp/app/features/news/domain/news_article.dart';

void main() {
  late NewsParser sut;

  setUp(() {
    sut = NewsParser();
  });

  group('NewsParser.parseList', () {
    test('parses article card with all fields', () {
      const html = '''
<article>
  <span>15</span><span>Мар</span>
  <h2><a href="https://ngieu.ru/ngieu-news/1234/" title="Тест">Новость дня</a></h2>
  <img src="https://ngieu.ru/img.jpg" />
  <p>Краткое описание новости</p>
  <a href="/author/admin/">Админ</a>
</article>
''';

      final result = sut.parseList(html);

      expect(result, hasLength(1));
      expect(result.first.id, 1234);
      expect(result.first.title, 'Новость дня');
      expect(result.first.url, 'https://ngieu.ru/ngieu-news/1234/');
      expect(result.first.excerpt, 'Краткое описание новости');
      expect(result.first.imageUrl, 'https://ngieu.ru/img.jpg');
      expect(result.first.author, 'Админ');
      expect(result.first.publishedAt?.day, 15);
      expect(result.first.publishedAt?.month, 3);
    });

    test('handles relative URL by prepending domain', () {
      const html = '''
<article>
  <h2><a href="/ngieu-news/5678/">Относительная ссылка</a></h2>
  <p>Текст</p>
</article>
''';

      final result = sut.parseList(html);

      expect(result.first.url, 'https://ngieu.ru/ngieu-news/5678/');
    });

    test('deduplicates articles by id', () {
      const html = '''
<article>
  <h2><a href="https://ngieu.ru/ngieu-news/100/">Дубль</a></h2>
  <p>Первый</p>
</article>
<article>
  <h2><a href="https://ngieu.ru/ngieu-news/100/">Дубль</a></h2>
  <p>Второй</p>
</article>
''';

      final result = sut.parseList(html);

      expect(result, hasLength(1));
    });

    test('skips article without valid ngieu-news link', () {
      const html = '''
<article>
  <h2><a href="https://ngieu.ru/other/123/">Не новость</a></h2>
  <p>Текст</p>
</article>
''';

      final result = sut.parseList(html);

      expect(result, isEmpty);
    });

    test('skips article with empty title', () {
      const html = '''
<article>
  <h2><a href="https://ngieu.ru/ngieu-news/999/"></a></h2>
  <p>Текст</p>
</article>
''';

      final result = sut.parseList(html);

      expect(result, isEmpty);
    });

    test('returns empty list for html without articles', () {
      const html = '<html><body><p>Нет новостей</p></body></html>';

      expect(sut.parseList(html), isEmpty);
    });

    test('parses div[id^="post-"] elements', () {
      const html = '''
<div id="post-42">
  <h2><a href="https://ngieu.ru/ngieu-news/42/">Из div</a></h2>
  <p>Описание</p>
</div>
''';

      final result = sut.parseList(html);

      expect(result, hasLength(1));
      expect(result.first.id, 42);
    });

    test('handles missing image gracefully', () {
      const html = '''
<article>
  <h2><a href="https://ngieu.ru/ngieu-news/55/">Без картинки</a></h2>
  <p>Текст</p>
</article>
''';

      final result = sut.parseList(html);

      expect(result.first.imageUrl, isNull);
    });
  });

  group('NewsParser.parseDetail', () {
    test('extracts content html and gallery images', () {
      final preview = const NewsArticle(
        id: 1,
        title: 'Тест',
        url: 'https://ngieu.ru/ngieu-news/1/',
        excerpt: '',
      );

      const html = '''
<html><body>
<div class="entry-content">
  <p>Текст статьи</p>
  <img src="https://ngieu.ru/photo1.jpg" />
  <img src="https://ngieu.ru/photo2.jpg" />
  <script>alert("xss")</script>
</div>
</body></html>
''';

      final result = sut.parseDetail(preview, html);

      expect(result.gallery, hasLength(2));
      expect(result.contentHtml, isNot(contains('script')));
      expect(result.contentHtml, contains('Текст статьи'));
    });

    test('returns fallback when no content element found', () {
      final preview = const NewsArticle(
        id: 2,
        title: 'Пустая',
        url: 'https://ngieu.ru/ngieu-news/2/',
        excerpt: '',
      );

      const html = '<html><body></body></html>';

      final result = sut.parseDetail(preview, html);

      expect(result.contentHtml, contains('Не удалось загрузить'));
    });
  });
}