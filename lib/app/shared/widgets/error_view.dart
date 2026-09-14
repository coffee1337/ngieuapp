import 'package:flutter/material.dart';
import 'package:ngieuapp/app/core/network/api_exception.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({required this.error, super.key, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  String _userMessage(Object error) {
    if (error is ApiException) return error.message;
    final text = error.toString();
    // Никогда не показываем технические toString() пользователю.
    if (text.startsWith('DioException') ||
        text.startsWith('FormatException') ||
        text.startsWith('TypeError') ||
        text.startsWith('Exception')) {
      return 'Нет соединения с сервером. Проверьте интернет и попробуйте снова.';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'Что-то пошло не так',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              _userMessage(error),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Попробовать снова'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
