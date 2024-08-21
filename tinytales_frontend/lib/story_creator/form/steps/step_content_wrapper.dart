import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/async_value_status.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/providers.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

// Handles showing loading, error and data content for the step
class StepContentWrapper extends ConsumerWidget {
  const StepContentWrapper({
    required this.child,
    this.loader,
    super.key,
  });

  /// The content to show when the step is in the data state
  final Widget child;

  final Widget? loader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(formStepStatusProvider);
    late Widget content;
    switch (status) {
      case AsyncValueStatus.data:
        content = Align(
          alignment: Alignment.topCenter,
          child: child,
        );
      case AsyncValueStatus.error:
        content = const _StoryCreatorFormError();
      case AsyncValueStatus.loading:
        content = loader ?? const _StorCreatorFormLoading();
    }
    return AnimatedSwitcher(
      duration: Durations.medium2,
      child: PageHorizontalPadding(child: content),
    );
  }
}

class _StoryCreatorFormError extends ConsumerWidget {
  const _StoryCreatorFormError();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormError(
      onTryAgain: () {
        ref.read(storyCreatorStateNotifierProvider.notifier).retryErrorAction();
      },
      onClose: () {
        ref.read(storyCreatorStateNotifierProvider.notifier).clearError();
      },
    );
  }
}

class _StorCreatorFormLoading extends StatelessWidget {
  const _StorCreatorFormLoading();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: context.l10n.storyCreatorA11yLoading,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
