import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tale_ai_frontend/form/form.dart';

part 'proposals_view.g.dart';

@CopyWith()
class ProposalsViewState extends FormStepState with EquatableMixin {
  const ProposalsViewState({
    this.selectedProposalIndex,
    this.storyProposals = const [],
  }) : super(isValid: true);

  final int? selectedProposalIndex;
  final List<StoryProposal> storyProposals;

  @override
  bool canProceed() {
    return selectedProposalIndex != null;
  }

  @override
  List<Object?> get props => [
        selectedProposalIndex,
        storyProposals,
        isValid,
      ];
}

class ProposalsView extends HookWidget {
  const ProposalsView({
    required this.header,
    required this.stepState,
    required this.onItemSelect,
    super.key,
  });

  final String header;
  final ProposalsViewState stepState;
  final ValueChanged<StoryProposal> onItemSelect;

  @override
  Widget build(BuildContext context) {
    final selectedProposal = useState<StoryProposal?>(
      stepState.selectedProposalIndex != null
          ? stepState.storyProposals[stepState.selectedProposalIndex!]
          : null,
    );
    final itemsMap = {
      for (var i = 0; i < stepState.storyProposals.length; i++)
        stepState.storyProposals[i]: SingleSelectionListItem(
          title: stepState.storyProposals[i].title,
          description: stepState.storyProposals[i].plot,
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
