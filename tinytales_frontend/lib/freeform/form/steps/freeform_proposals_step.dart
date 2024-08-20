import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/freeform/data/freeform_proposals.dart';
import 'package:tale_ai_frontend/freeform/form/freeform_navigation_buttons.dart';
import 'package:tale_ai_frontend/freeform/state/state.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

part 'freeform_proposals_step.g.dart';

@riverpod
FreeformProposalsState freeformProposalsStepState(
  FreeformProposalsStepStateRef ref,
) {
  return ref.watch(freeformNotifierProvider).proposalsStep;
}

class FreeformProposalsStep extends ConsumerWidget {
  const FreeformProposalsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScrollableContentScaffold(
      scrollableContent: FreeformProposalsView(
        header: context.l10n.storyCreatorTalesOverviewStepQuestion,
        stepState: ref.watch(freeformProposalsStepStateProvider),
        onItemSelect: (value) {
          ref.read(freeformNotifierProvider.notifier).setStoryProposal(value);
        },
      ),
      bottomContent: const FreeformNavigationButtons(),
    );
  }
}

class FreeformProposalsView extends HookWidget {
  const FreeformProposalsView({
    required this.header,
    required this.stepState,
    required this.onItemSelect,
    super.key,
  });

  final String header;
  final FreeformProposalsState stepState;
  final ValueChanged<FreeformProposal> onItemSelect;

  @override
  Widget build(BuildContext context) {
    final selectedProposal = useState<FreeformProposal?>(
      stepState.selectedProposalIndex != null
          ? stepState.proposals[stepState.selectedProposalIndex!]
          : null,
    );
    final itemsMap = {
      for (var i = 0; i < stepState.proposals.length; i++)
        stepState.proposals[i]: SingleSelectionListItem(
          title: stepState.proposals[i].title,
          description: stepState.proposals[i].plot,
        ),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FormStepHeader(
          title: header,
        ),
        Flexible(
          child: SingleSelectionList(
            items: itemsMap.values.toList(),
            currentValue: itemsMap[selectedProposal.value],
            onChanged: (value) {
              final overview = value;

              final chosenProposal = itemsMap.entries
                  .firstWhere((element) => element.value == overview)
                  .key;

              selectedProposal.value = chosenProposal;

              if (overview != null) {
                onItemSelect(chosenProposal);
              }
            },
          ),
        ),
      ],
    );
  }
}
