import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/news_article.dart';
import '../domain/news_repository.dart';
part 'news_list_controller.g.dart';

@riverpod
class NewsListController extends _$NewsListController {
  @override
  Stream<List<NewsArticle>> build() {
    return ref.read(newsRepositoryProvider).watchList();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<NewsArticle>>().copyWithPrevious(state);
    ref.invalidateSelf();
    await future;
  }
}