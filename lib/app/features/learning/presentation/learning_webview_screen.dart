import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:ngieuapp/app/core/network/api_endpoints.dart';
import 'package:ngieuapp/app/shared/widgets/error_view.dart';

class LearningWebViewScreen extends StatefulWidget {
  const LearningWebViewScreen({super.key});
  static const _initialUrl = ApiEndpoints.learningUrl;

  @override
  State<LearningWebViewScreen> createState() => _LearningWebViewScreenState();
}

class _LearningWebViewScreenState extends State<LearningWebViewScreen> {
  InAppWebViewController? _controller;
  late final PullToRefreshController _pullToRefresh = PullToRefreshController(
    settings: PullToRefreshSettings(color: const Color(0xFF9F003D)),
    onRefresh: () async {
      await _controller?.reload();
    },
  );
  double _progress = 0;
  bool _hasError = false;
  String? _errorText;
  bool _canGoBack = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _handleBack() async {
    if (_controller != null && await _controller!.canGoBack()) {
      _controller!.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_canGoBack,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) await _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Обучение'),
          bottom: _progress < 1
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(2),
                  child: LinearProgressIndicator(value: _progress),
                )
              : null,
          actions: [
            IconButton(
              icon: const Icon(Icons.home_outlined),
              onPressed: () => _controller?.loadUrl(
                urlRequest: URLRequest(
                  url: WebUri(LearningWebViewScreen._initialUrl),
                ),
              ),
            ),
          ],
        ),
        body: _hasError
            ? ErrorView(
                error: _errorText ?? 'Не удалось загрузить',
                onRetry: () {
                  setState(() => _hasError = false);
                  _controller?.reload();
                },
              )
            : InAppWebView(
                pullToRefreshController: _pullToRefresh,
                initialUrlRequest: URLRequest(
                  url: WebUri(LearningWebViewScreen._initialUrl),
                ),
                initialSettings: InAppWebViewSettings(
                  transparentBackground: true,
                  useOnDownloadStart: true,
                  useShouldOverrideUrlLoading: true,
                  userAgent:
                      'Mozilla/5.0 (Linux; Android 13) NGIEU-Mobile/1.0 Mobile Safari/537.36',
                ),
                onWebViewCreated: (c) => _controller = c,
                onLoadStart: (_, __) {
                  setState(() {
                    _hasError = false;
                    _progress = 0;
                  });
                },
                onProgressChanged: (_, p) {
                  if (p == 100) _pullToRefresh.endRefreshing();
                  setState(() => _progress = p / 100);
                },
                onLoadStop: (c, _) async {
                  _canGoBack = await c.canGoBack();
                  if (mounted) setState(() {});
                },
                onReceivedError: (_, request, error) {
                  if (request.isForMainFrame ?? false) {
                    setState(() {
                      _hasError = true;
                      _errorText = 'Ошибка: ${error.description}';
                    });
                  }
                  _pullToRefresh.endRefreshing();
                },
                onReceivedHttpError: (_, request, response) {
                  if ((request.isForMainFrame ?? false) &&
                      (response.statusCode ?? 0) >= 500) {
                    setState(() {
                      _hasError = true;
                      _errorText = 'Сервер вернул ${response.statusCode}';
                    });
                  }
                },
                shouldOverrideUrlLoading: (c, action) async {
                  final host = action.request.url?.host ?? '';
                  if (host.contains('ngiei.mcdir.ru') ||
                      host.contains('ngieu.ru')) {
                    return NavigationActionPolicy.ALLOW;
                  }
                  return NavigationActionPolicy.CANCEL;
                },
                onDownloadStartRequest: (c, req) async {
                  // Отдаём ОС — пусть сохраняет файл через Download Manager
                },
              ),
      ),
    );
  }
}
