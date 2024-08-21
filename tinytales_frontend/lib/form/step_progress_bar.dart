import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/theme/theme.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

part 'step_progress_bar.g.dart';

@immutable
@CopyWith()
class StepProgressBarState with EquatableMixin {
  const StepProgressBarState({
    required this.previousStepIndex,
    required this.currentStepIndex,
  });
  final int previousStepIndex;
  final int currentStepIndex;

  @override
  List<Object?> get props => [previousStepIndex, currentStepIndex];

  @override
  bool? get stringify => true;
}

@riverpod
class StepProgressBarNotifier extends _$StepProgressBarNotifier {
  @override
  StepProgressBarState build() => const StepProgressBarState(
        previousStepIndex: 0,
        currentStepIndex: 0,
      );

  void updateStep(int newStepIndex) {
    final previousStepIndex = state.currentStepIndex;
    state = StepProgressBarState(
      previousStepIndex: previousStepIndex,
      currentStepIndex: newStepIndex,
    );
  }
}

// Warning: as notifier is only used in this widget the state will go
// away when the widget is removed from the widget tree.
// If you want to keep the state then you have to watch the notifier
// in a parent widget.
class StepProgressBar extends ConsumerWidget {
  const StepProgressBar({
    required this.stepsCount,
    super.key,
  });

  final int stepsCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressBarState = ref.watch(stepProgressBarNotifierProvider);
    final previousStepIndex = progressBarState.previousStepIndex;
    final currentStepIndex = progressBarState.currentStepIndex;
    return AnimatedStepProgressBar(
      currentStepIndex: currentStepIndex,
      previousStepIndex: previousStepIndex,
      stepsCount: stepsCount,
    );
  }
}

/// A linear progress bar that animates between steps.
class AnimatedStepProgressBar extends StatelessWidget {
  const AnimatedStepProgressBar({
    required this.previousStepIndex,
    required this.currentStepIndex,
    required this.stepsCount,
    super.key,
  });

  final int previousStepIndex;
  final int currentStepIndex;
  final int stepsCount;

  @override
  Widget build(BuildContext context) {
    final verticalPadding = ResponsiveValue(
      context,
      conditionalValues: [
        const Condition.equals(
          name: DESKTOP,
          value: EdgeInsets.only(top: 40, bottom: 48),
        ),
      ],
      defaultValue: const EdgeInsets.only(top: 24, bottom: 24),
    ).value;

    return AnimatedPadding(
      duration: Durations.short2,
      padding: verticalPadding,
      child: PageHorizontalPadding(
        child: TweenAnimationBuilder<double>(
          tween: Tween(
            begin: (previousStepIndex + 1) / stepsCount,
            end: (currentStepIndex + 1) / stepsCount,
          ),
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 150),
          builder: (context, value, child) => LinearProgressIndicator(
            semanticsValue: context.l10n
                .a11yStepProgressBarLabel(currentStepIndex + 1, stepsCount),
            value: value,
          ),
        ),
      ),
    );
  }
}
