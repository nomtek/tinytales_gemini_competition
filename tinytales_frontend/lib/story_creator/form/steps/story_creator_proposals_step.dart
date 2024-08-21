import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/providers.dart';
import 'package:tale_ai_frontend/story_creator/form/story_creator_navigation_button.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class StoryCreatorProposalsStep extends HookConsumerWidget {
  const StoryCreatorProposalsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepState = ref.watch(storyProposalsStepProvider);
    return AppScrollableContentScaffold(
      scrollableContent: ProposalsView(
        header: context.l10n.storyCreatorTalesOverviewStepQuestion,
        stepState: stepState,
        onItemSelect: (chosenProposal) => ref
            .read(storyCreatorStateNotifierProvider.notifier)
            .setStoryProposal(chosenProposal),
      ),
      bottomContent: const StoryCreatorNavigationButtons(),
    );
  }
}
