import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';

class LoadMoreError extends StatelessWidget {
  const LoadMoreError({
    required this.onRetry,
    super.key,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            color: context.colors.errorContainer,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  color: context.colors.onErrorContainer,
                ),
                const Gap(8),
                Text(
                  context.l10n.loadMoreError,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colors.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          FilledButton(
            onPressed: onRetry,
            child: Text(context.l10n.actionRetry),
          ),
        ],
      ),
    );
  }
}
