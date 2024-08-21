import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/debug/talker.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/story/data/life_value.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/moral/moral_providers.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/providers.dart';
import 'package:tale_ai_frontend/story_creator/form/story_creator_navigation_button.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';
import 'package:tale_ai_frontend/theme/theme.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class StoryCreatorMoralSelectionSubstep extends ConsumerWidget {
  const StoryCreatorMoralSelectionSubstep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyMoral = ref.watch(storyMoralStepProvider);
    return AppScrollableContentScaffold(
      scrollableContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormStepHeader(
            title: context.l10n.storyCreatorMoralStepTitle,
            subtitle: context.l10n.storyCreatorMoralStepSubTitle,
          ),
          const Gap(32),
          _MoralSuggestionsSection(
            initialSelectedSuggestions: storyMoral.selectedSuggestionsIds,
          ),
          const Gap(32),
          CustomStepTile(
            title: context.l10n.storyCreatorMoralStepOwnMoralButton,
            onClicked: () => ref
                .read(storyCreatorStateNotifierProvider.notifier)
                .setMoralStepType(StepType.creation),
          ),
        ],
      ),
      bottomContent: const StoryCreatorNavigationButtons(),
    );
  }
}

class _MoralSuggestionsSection extends HookConsumerWidget {
  const _MoralSuggestionsSection({
    this.initialSelectedSuggestions = const [],
  });

  final List<String> initialSelectedSuggestions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(lifeValuesProvider).when(
          data: (suggestions) => _MoralSuggestionsSectionContent(
            suggestions: suggestions,
            savedSelectedSuggestions: initialSelectedSuggestions,
          ),
          error: (e, st) {
            ref.read(talkerProvider).error(e, st);
            return AppErrorWidget(
              shouldScroll: false,
              onTryAgain: () => ref.invalidate(lifeValuesProvider),
            );
          },
          loading: CircularProgressIndicator.new,
        );
  }
}

const _selectedSuggestionsLimit = 3;

class _MoralSuggestionsSectionContent extends HookConsumerWidget {
  const _MoralSuggestionsSectionContent({
    required this.suggestions,
    required this.savedSelectedSuggestions,
  });

  final List<LifeValue> suggestions;
  final List<String> savedSelectedSuggestions;

  void _updateMoralSuggestions(
    List<String> selectedSuggestions,
    WidgetRef ref,
  ) {
    ref
        .read(storyCreatorStateNotifierProvider.notifier)
        .selectStoryMoralSuggestions(
          selectedSuggestions,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSuggestions = useState(savedSelectedSuggestions);

    return Wrap(
      spacing: 8,
      children: List<Widget>.generate(
        suggestions.length,
        (index) {
          final suggestion = suggestions[index];
          return _MoralSuggestionChip(
            name: suggestion.name,
            isSelected: selectedSuggestions.value.contains(suggestion.id),
            selectedChipsCount: selectedSuggestions.value.length,
            onPressedSelected: () {
              selectedSuggestions.value = selectedSuggestions.value
                  .where((element) => element != suggestion.id)
                  .toList();
              _updateMoralSuggestions(selectedSuggestions.value, ref);
            },
            onPressedUnSelected: () {
              selectedSuggestions.value = [
                ...selectedSuggestions.value,
                suggestion.id,
              ];
              _updateMoralSuggestions(selectedSuggestions.value, ref);
            },
          );
        },
      ),
    );
  }
}

class _MoralSuggestionChip extends StatelessWidget {
  const _MoralSuggestionChip({
    required this.name,
    required this.isSelected,
    required this.selectedChipsCount,
    required this.onPressedSelected,
    required this.onPressedUnSelected,
  });

  final String name;
  final bool isSelected;
  final int selectedChipsCount;
  final VoidCallback onPressedSelected;
  final VoidCallback onPressedUnSelected;

  @override
  Widget build(BuildContext context) {
    final content = switch (isSelected) {
      true => ActionChip.elevated(
          elevation: 0,
          color: WidgetStatePropertyAll(
            context.colors.secondaryContainer,
          ),
          onPressed: onPressedSelected,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name),
              const Gap(8),
              const Icon(
                size: 18,
                Icons.close,
              ),
            ],
          ),
        ),
      false => ActionChip(
          onPressed: selectedChipsCount < _selectedSuggestionsLimit
              ? onPressedUnSelected
              : null,
          label: Text(name),
        ),
    };

    final label = isSelected
        ? context.l10n.storCreatorMoralSuggestionsA11yLabelSelected(
            name,
            selectedChipsCount,
            _selectedSuggestionsLimit,
          )
        : context.l10n.storCreatorMoralSuggestionsA11yLabel(
            name,
            selectedChipsCount,
            _selectedSuggestionsLimit,
          );

    return Semantics(
      inMutuallyExclusiveGroup: false,
      button: true,
      selected: defaultTargetPlatform == TargetPlatform.iOS ? isSelected : null,
      checked:
          defaultTargetPlatform == TargetPlatform.android ? isSelected : null,
      label: label,
      child: ExcludeSemantics(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: content,
        ),
      ),
    );
  }
}
