import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';

/// A widget to display when a list is empty.
class EmptyList extends StatelessWidget {
  const EmptyList({
    required this.title,
    required this.message,
    this.image,
    this.action,
    this.shrinkContent = true,
    super.key,
  });

  final Widget? image;
  final String title;
  final String message;
  final Widget? action;

  /// make content as small as possible if true
  /// (imposes constraints on a widget)
  final bool shrinkContent;

  @override
  Widget build(BuildContext context) {
    final content = _EmptyContent(
      title: title,
      message: message,
      image: image,
      action: action,
    );
    return shrinkContent ? SizedBox.shrink(child: content) : content;
  }
}

class _EmptyContent extends StatelessWidget {
  const _EmptyContent({
    required this.title,
    required this.message,
    this.image,
    this.action,
  });

  final Widget? image;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != null)
            Flexible(
              child: ExcludeSemantics(child: image),
            ),
          if (image != null) const Gap(16),
          MergeSemantics(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
                const Gap(16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
          ),
          if (action != null) const Gap(16),
          if (action != null) action!,
        ],
      ),
    );
  }
}
