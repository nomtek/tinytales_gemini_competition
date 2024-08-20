import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/theme/theme.dart';
import 'package:tale_ai_frontend/widgets/scroll_or_fit_bottom.dart';

/// Manages how the content should scroll.
/// Different behavior is applied on mobile and desktop.
class AppScrollableContentScaffold extends StatelessWidget {
  const AppScrollableContentScaffold({
    required this.scrollableContent,
    required this.bottomContent,
    super.key,
  });

  final Widget scrollableContent;
  final Widget bottomContent;

  @override
  Widget build(BuildContext context) {
    return ScrollOrFitBottom(
      scrollableContent: scrollableContent,
      bottomContent: bottomContent,
      behavior: !context.isDesktopBreakpoint
          ? ScrollOrFitBottomBehavior.pushToBottom
          : ScrollOrFitBottomBehavior.alwaysScroll,
    );
  }
}
