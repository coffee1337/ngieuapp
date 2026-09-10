import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ngieuapp/app/core/network/connectivity_provider.dart';
import 'package:ngieuapp/app/features/campus/domain/campus_catalog.dart';
import 'package:ngieuapp/app/shared/widgets/error_view.dart';

class CampusDirectionsScreen extends ConsumerStatefulWidget {
  const CampusDirectionsScreen({super.key});

  @override
  ConsumerState<CampusDirectionsScreen> createState() =>
      _CampusDirectionsScreenState();
}

class _CampusDirectionsScreenState
    extends ConsumerState<CampusDirectionsScreen> {
  InAppWebViewController? _controller;
  double _progress = 0;
  String? _error;

  static final _mapUrl = WebUri(
    'https://yandex.ru/maps/?text=${Uri.encodeComponent(CampusCatalog.mainCampusAddress)}',
  );

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(connectivityProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Маршрут до корпуса'),
        bottom: _progress > 0 && _progress < 1
            ? PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: LinearProgressIndicator(value: _progress),
              )
            : null,
        actions: [
          IconButton(
            tooltip: 'Обновить',
            onPressed: isOnline ? () => _controller?.reload() : null,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: !isOnline
          ? ErrorView(
              error:
                  'Для построения маршрута нужен интернет. '
                  'Поиск кабинета и этажа доступен офлайн.',
              onRetry: () => ref.invalidate(connectivityProvider),
            )
          : _error != null
          ? ErrorView(
              error: _error!,
              onRetry: () {
                setState(() => _error = null);
                _controller?.loadUrl(urlRequest: URLRequest(url: _mapUrl));
              },
            )
          : InAppWebView(
              initialUrlRequest: URLRequest(url: _mapUrl),
              initialSettings: InAppWebViewSettings(
                transparentBackground: true,
                useShouldOverrideUrlLoading: true,
              ),
              onWebViewCreated: (controller) => _controller = controller,
              onProgressChanged: (_, progress) {
                if (mounted) setState(() => _progress = progress / 100);
              },
              onReceivedError: (_, request, error) {
                if (mounted && (request.isForMainFrame ?? false)) {
                  setState(() => _error = error.description);
                }
              },
              shouldOverrideUrlLoading: (_, action) async {
                final host = action.request.url?.host ?? '';
                return host.endsWith('yandex.ru') || host.endsWith('yandex.com')
                    ? NavigationActionPolicy.ALLOW
                    : NavigationActionPolicy.CANCEL;
              },
            ),
    );
  }
}
