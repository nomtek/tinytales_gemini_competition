import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tale_ai_frontend/gen/assets.gen.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    this.errorTitle,
    this.errorDescription,
    this.onTryAgain,
    this.onClose,
    this.shouldScroll = true,
    super.key,
  });

  /// if not provided then action is not visible
  final VoidCallback? onTryAgain;

  /// if not provided then action is not visible
  final VoidCallback? onClose;

  /// if not provided then default text is used
  final String? errorTitle;

  /// if not provided then default text is used
  final String? errorDescription;

  final bool shouldScroll;

  @override
  Widget build(BuildContext context) {
    late final Widget content;

    if (shouldScroll) {
      if (context.isDesktopBreakpoint) {
        // on desktop we want buttons to be just below the content
        content = Center(
          child: ScrollOrFitBottom(
            behavior: ScrollOrFitBottomBehavior.alwaysScroll,
            scrollableContent: AppErrorContent(
              errorTitle: errorTitle,
              errorDescription: errorDescription,
            ),
            bottomContent: AppErrorActions(
              onClose: onClose,
              onTryAgain: onTryAgain,
            ),
          ),
        );
      } else {
        // on mobile and tablet we want buttons to be at the bottom
        content = LayoutBuilder(
          builder: (context, constraints) {
            // We want to have some space for buttons as scrollable content
            // is pushed to the top by bottom content when it's small.
            // 150 is a magic number that looks good.
            const buttonsSpace = 150;
            return ScrollOrFitBottom(
              scrollableContent: SizedBox(
                height: constraints.maxHeight - buttonsSpace,
                child: AppErrorContent(
                  errorTitle: errorTitle,
                  errorDescription: errorDescription,
                ),
              ),
              bottomContent: AppErrorActions(
                onClose: onClose,
                onTryAgain: onTryAgain,
              ),
            );
          },
        );
      }
    } else {
      if (context.isDesktopBreakpoint) {
        // on desktop we want buttons to be just below the content
        content = Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppErrorContent(
                errorTitle: errorTitle,
                errorDescription: errorDescription,
              ),
              AppErrorActions(
                onClose: onClose,
                onTryAgain: onTryAgain,
              ),
            ],
          ),
        );
      } else {
        // on mobile and tablet we want buttons to be at the bottom
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Center(
                child: AppErrorContent(
                  errorTitle: errorTitle,
                  errorDescription: errorDescription,
                ),
              ),
            ),
            AppErrorActions(
              onClose: onClose,
              onTryAgain: onTryAgain,
            ),
          ],
        );
      }
    }

    return ColoredBox(
      color: context.colors.surfaceContainerHigh,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: content,
        ),
      ),
    );
  }
}

class AppErrorContent extends StatelessWidget {
  const AppErrorContent({
    this.errorTitle,
    this.errorDescription,
    super.key,
  });

  /// if not provided then default text is used
  final String? errorTitle;

  /// if not provided then default text is used
  final String? errorDescription;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(child: Assets.images.errorImage.svg()),
          const Gap(40),
          Text(
            errorTitle ?? context.l10n.genericErrorTitle,
            style: context.textTheme.headlineSmall!.copyWith(
              color: context.colors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(16),
          Text(
            errorDescription ?? context.l10n.genericErrorDescription,
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colors.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class AppErrorActions extends StatelessWidget {
  const AppErrorActions({
    this.onTryAgain,
    this.onClose,
    super.key,
  });

  final VoidCallback? onTryAgain;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return AppButtonBar(
      primaryButton: onTryAgain != null
          ? FilledButton(
              onPressed: onTryAgain,
              child: Text(context.l10n.tryAgain),
            )
          : null,
      secondaryButton: onClose != null
          ? OutlinedButton(
              onPressed: onClose,
              child: Text(context.l10n.goBack),
            )
          : null,
    );
  }
}
