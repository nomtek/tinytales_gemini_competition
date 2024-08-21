import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/providers.dart';
import 'package:tale_ai_frontend/story_creator/form/story_creator_navigation_button.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class StoryCreatorLengthStep extends HookConsumerWidget {
  const StoryCreatorLengthStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsMap = {
      StoryLength.short: SingleSelectionListItem(
        title: context.l10n.storyCreatorLengthStepShort,
        description: context.l10n.storyCreatorLengthStepShortDescription,
      ),
      StoryLength.medium: SingleSelectionListItem(
        title: context.l10n.storyCreatorLengthStepMedium,
        description: context.l10n.storyCreatorLengthStepMediumDescription,
      ),
      StoryLength.long: SingleSelectionListItem(
        title: context.l10n.storyCreatorLengthStepLong,
        description: context.l10n.storyCreatorLengthStepLongDescription,
      ),
    };

    final length = ref.watch(storyLengthProvider);

    return AppScrollableContentScaffold(
      scrollableContent: Column(
        children: [
          FormStepHeader(
            title: context.l10n.storyCreatorLengthStepQuestion,
          ),
          SingleSelectionList(
            items: itemsMap.values.toList(),
            currentValue: itemsMap[length],
            onChanged: (value) {
              ref.read(storyCreatorStateNotifierProvider.notifier).setLength(
                    itemsMap.entries
                        .firstWhere((element) => element.value == value)
                        .key,
                  );
            },
          ),
        ],
      ),
      bottomContent: const StoryCreatorNavigationButtons(),
    );
  }
}
