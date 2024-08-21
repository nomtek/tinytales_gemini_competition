import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/extensions.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/story_creator/form/components.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/providers.dart';
import 'package:tale_ai_frontend/story_creator/form/story_creator_navigation_button.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class StorCreatorMoralCreationSubstep extends ConsumerWidget {
  const StorCreatorMoralCreationSubstep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyMoral = ref.watch(storyMoralStepProvider);
    return AppScrollableContentScaffold(
      scrollableContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormStepHeader(
            title: context.l10n.storyCreatorMoralStepTitle,
          ),
          _MoralInputSection(
            storyMoral,
          ),
        ],
      ),
      bottomContent: const StoryCreatorNavigationButtons(),
    );
  }
}

class _MoralInputSection extends HookConsumerWidget {
  const _MoralInputSection(this.storyMoral);

  final MoralStepState storyMoral;

  static const _maxLength = 250;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moralInputController =
        useTextEditingController(text: storyMoral.moral);
    final moralScrollController = useScrollController();
    final isMoralAnimationStopped = useState(true);
    final charactersCount = useState(0);
    final isAutofillInProgress = storyMoral.isAIAutofillInProgress;
    final moralEditable =
        isMoralAnimationStopped.value && !isAutofillInProgress;
    // Listen to the state changes of character name and description
    // after state change, and update the text fields accordingly if
    // the values are different, it means that the moral is
    // updated from the AI autofill button.
    ref.listen<StoryCreatorState>(
      storyCreatorStateNotifierProvider,
      (prevState, nextState) {
        final autofillMoralChanged =
            moralInputController.value.text != nextState.moralStep.moral &&
                nextState.moralStep.moral.isNotNullOrBlank;
        if (autofillMoralChanged) {
          semanticsAnnouncement(
            context: context,
            text: context.l10n.a11yMoralAiAutofillResult(
              nextState.moralStep.moral ?? '',
            ),
          );
        }
        // canceling previous animation
        // here we will have also a problem when moral will change faster
        // than the animation, we should cancel the previous animation
        // but that will require refactoring the whole animation
        if (prevState?.moralStep.moral != nextState.moralStep.moral) {
          updateTextFieldInChunks(
            context: context,
            controller: moralInputController,
            scrollController: moralScrollController,
            duration: const Duration(milliseconds: 3000),
            value: nextState.moralStep.moral,
            onUpdateStart: () => isMoralAnimationStopped.value = false,
            onUpdateEnd: () => isMoralAnimationStopped.value = true,
          );
        }
      },
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Stack(
          children: [
            ValidationTextField(
              textController: moralInputController,
              onChanged: (value) {
                charactersCount.value = value.characters.length;
                ref
                    .read(storyCreatorStateNotifierProvider.notifier)
                    .setStoryMoral(value);
              },
              validation: storyMoral.validation,
              isEnabled: moralEditable,
              scrollController: moralScrollController,
              minLines: 4,
              maxLines: 4,
              maxLength: _maxLength,
              hintText: context.l10n.storyCreatorMoralStepInputHint,
              labelText: context.l10n.storyCreatorMoralStepInputLabel,
              helperText: '',
            ),
            if (isAutofillInProgress) const TextFieldCircleIndicator(),
          ],
        ),
        Row(
          children: [
            if (storyMoral.validation?.showAutofixForOneField ?? false)
              AutofixTextButton(
                onPressed: () {
                  final suggestedMoral =
                      storyMoral.validation?.suggestedVersion.content ?? '';
                  moralInputController.text = suggestedMoral;
                  announceMoralInputAutofix(
                    context: context,
                    moral: suggestedMoral,
                  );

                  ref
                      .read(storyCreatorStateNotifierProvider.notifier)
                      .setStoryMoral(
                        storyMoral.validation?.suggestedVersion.content ?? '',
                      );
                },
              ),
            const Spacer(),
            AiAutofillButton(
              onPressed: moralEditable
                  ? () => ref
                      .read(storyCreatorStateNotifierProvider.notifier)
                      .moralAIAutofill()
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
