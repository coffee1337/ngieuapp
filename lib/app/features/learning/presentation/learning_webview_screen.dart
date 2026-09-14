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
  // Reusing the native web view preserves sessionStorage and in-memory login
  // state when the user switches between the application tabs.
  static final _keepAlive = InAppWebViewKeepAlive();
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

  Future<bool> _handleBack() async {
    if (_controller != null && await _controller!.canGoBack()) {
      await _controller!.goBack();
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
                keepAlive: _keepAlive,
                pullToRefreshController: _pullToRefresh,
                initialUrlRequest: URLRequest(
                  url: WebUri(LearningWebViewScreen._initialUrl),
                ),
                initialSettings: InAppWebViewSettings(
                  cacheEnabled: true,
                  clearCache: false,
                  incognito: false,
                  sharedCookiesEnabled: true,
                  transparentBackground: true,
                  useOnDownloadStart: true,
                  useShouldOverrideUrlLoading: true,
                ),
                onWebViewCreated: (c) => _controller = c,
                onLoadStart: (_, __) {
                  if (!mounted) return;
                  setState(() {
                    _hasError = false;
                    _progress = 0;
                  });
                },
                onProgressChanged: (_, p) {
                  if (!mounted) return;
                  if (p == 100) _pullToRefresh.endRefreshing();
                  setState(() => _progress = p / 100);
                },
                onLoadStop: (c, _) async {
                  _canGoBack = await c.canGoBack();
                  if (mounted) setState(() {});
                },
                onReceivedError: (_, request, error) {
                  if (!mounted) return;
                  if (request.isForMainFrame ?? false) {
                    setState(() {
                      _hasError = true;
                      _errorText = 'Ошибка: ${error.description}';
                    });
                  }
                  _pullToRefresh.endRefreshing();
                },
                onReceivedHttpError: (_, request, response) {
                  if (!mounted) return;
                  if ((request.isForMainFrame ?? false) &&
                      (response.statusCode ?? 0) >= 500) {
                    setState(() {
                      _hasError = true;
                      _errorText = 'Сервер вернул ${response.statusCode}';
                    });
                  }
                },
                shouldOverrideUrlLoading: (c, action) async {
                  final scheme = action.request.url?.scheme.toLowerCase();
                  // Authentication can legitimately redirect through another
                  // HTTPS host. Blocking that redirect looked like a logout,
                  // especially on iOS where WKWebView uses the real Safari UA.
                  if (scheme == 'https' || scheme == 'http') {
                    return NavigationActionPolicy.ALLOW;
                  }
                  return NavigationActionPolicy.CANCEL;
                },
                onDownloadStartRequest: (c, req) async {
                  // The external browser owns the actual download. It may
                  // require login again because WebView cookies are private.
                  final messenger = ScaffoldMessenger.of(context);
                  final scheme = req.url.scheme.toLowerCase();
                  try {
                    if (scheme != 'https' && scheme != 'http') {
                      throw const FormatException('Unsupported download URL');
                    }
                    await InAppBrowser.openWithSystemBrowser(url: req.url);
                  } on Object {
                    if (!mounted) return;
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Не удалось открыть загрузку в браузере'),
                      ),
                    );
                  }
                },
              ),
      ),
    );
  }
}
