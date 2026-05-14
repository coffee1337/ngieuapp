import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ngieuapp/app/features/news/presentation/news_list_controller.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';
import 'package:ngieuapp/app/shared/widgets/error_view.dart';
import 'package:ngieuapp/app/shared/widgets/fullscreen_image_viewer.dart';
import 'package:ngieuapp/app/shared/widgets/skeleton.dart';

class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({required this.articleId, super.key});

  final int articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewAsync = ref.watch(newsPreviewByIdProvider(articleId));
    final showImages = ref.watch(appSettingsProvider).showNewsImages;

    return Scaffold(
      appBar: AppBar(title: const Text('Новость')),
      body: previewAsync.when(
        loading: () => const NewsCardSkeleton(),
        error: (e, _) => ErrorView(error: e),
        data: (preview) {
          if (preview == null) {
            return const Center(child: Text('Новость не найдена'));
          }
          final detailAsync = ref.watch(newsDetailProvider(preview));
          return detailAsync.when(
            loading: () => const NewsCardSkeleton(),
            error: (e, _) => ErrorView(
              error: e,
              onRetry: () => ref.invalidate(newsDetailProvider(preview)),
            ),
            data: (detail) {
              final theme = Theme.of(context);
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showImages &&
                        preview.imageUrl != null &&
                        preview.imageUrl!.isNotEmpty)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Material(
                          color: theme.colorScheme.surfaceContainerHigh,
                          child: InkWell(
                            onTap: () => showFullscreenImageViewer(
                              context,
                              preview.imageUrl,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: preview.imageUrl!,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                color: theme.colorScheme.surfaceContainerHigh,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (preview.publishedAt != null)
                            Text(
                              DateFormat(
                                'd MMMM y',
                                'ru_RU',
                              ).format(preview.publishedAt!),
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          const SizedBox(height: 6),
                          Text(
                            preview.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Html(
                        data: detail.contentHtml,
                        extensions: [
                          OnImageTapExtension(
                            onImageTap: (url, _, __) =>
                                showFullscreenImageViewer(context, url),
                          ),
                        ],
                        style: {
                          'body': Style(
                            fontSize: FontSize(16),
                            lineHeight: const LineHeight(1.5),
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          'p': Style(margin: Margins.only(bottom: 12)),
                          'a': Style(color: theme.colorScheme.primary),
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
