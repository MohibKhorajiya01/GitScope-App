import 'package:flutter/material.dart';
import '../../core/errors/failures.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final (icon, title, subtitle) = _parseError(error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, size: 36, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text(AppStrings.tryAgain),
              ),
            ],
          ],
        ),
      ),
    );
  }

  (IconData, String, String) _parseError(Object error) {
    if (error is NetworkFailure) {
      return (
        Icons.wifi_off_rounded,
        'No Connection',
        AppStrings.errorNetwork,
      );
    }
    if (error is NotFoundFailure) {
      return (
        Icons.person_search_rounded,
        'User Not Found',
        AppStrings.errorNotFound,
      );
    }
    if (error is RateLimitFailure) {
      return (
        Icons.timer_rounded,
        'Rate Limited',
        AppStrings.errorRateLimit,
      );
    }
    if (error is TokenMissingFailure) {
      return (
        Icons.key_rounded,
        'Token Required',
        AppStrings.errorToken,
      );
    }
    // Generic server / unknown
    return (
      Icons.error_outline_rounded,
      AppStrings.errorTitle,
      error is ServerFailure ? (error).message : AppStrings.errorServer,
    );
  }
}
