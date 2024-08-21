import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/router/router.dart';
import 'package:tale_ai_frontend/story/providers.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class NextAdventureProposals extends HookConsumerWidget {
  const NextAdventureProposals({
    required this.storyId,
    super.key,
  });

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      nextAdventureIdProvider,
      (_, next) {
        if (next != null) {
          StoryPageRoute(storyId: next).go(context);
        }
      },
    );

    final nextAdventureState = ref.watch(nextAdventureNotifierProvider);

    final content = switch (nextAdventureState.screenStatus) {
      NextAdventureScreenStatus.loading => () {
          switch (nextAdventureState.loadingState) {
            case LoadingState.loading:
              return const _NextAdventureLoading();
            case LoadingState.creatingStory:
              return const StoryCreateLoader();
            case null:
              throw StateError('should not be null at this point');
          }
        }(),
      NextAdventureScreenStatus.data => _NextAdventureProposalsContent(
          storyId: storyId,
        ),
      NextAdventureScreenStatus.error => _NextAdventureError(
          storyId: storyId,
        ),
    };

    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () {
            HomeRoute().go(context);
          },
        ),
      ),
      body: content,
    );
  }
}

class _NextAdventureError extends ConsumerWidget {
  const _NextAdventureError({required this.storyId});

  final String storyId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextAdventureState = ref.watch(nextAdventureNotifierProvider);
    return FormError(
      onTryAgain: () {
        ref.read(nextAdventureNotifierProvider.notifier).retryErrorAction();
      },
      onClose: () {
        // when error occurs on loading proposals the list will be empty
        // and hence we cannot show the proposals so we go back
        // to previous screen
        if (nextAdventureState.proposals.storyProposals.isEmpty) {
          context.pop();
        }
        ref.read(nextAdventureNotifierProvider.notifier).clearError();
      },
    );
  }
}

class _NextAdventureLoading extends StatelessWidget {
  const _NextAdventureLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _NextAdventureProposalsContent extends ConsumerWidget {
  const _NextAdventureProposalsContent({required this.storyId});

  final String storyId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: AppMaxContentWidth(
        child: PageHorizontalPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ProposalsView(
                header: context.l10n.nextAdventureProposalHeader,
                onItemSelect: (value) {
                  ref
                      .watch(nextAdventureNotifierProvider.notifier)
                      .setStoryProposal(value);
                },
                stepState: ref.watch(nextAdventureNotifierProvider).proposals,
              ),
              const Gap(8),
              _RegenerateButton(
                storyId: storyId,
              ),
              _NavigationButtons(
                canProceed: ref
                    .watch(nextAdventureNotifierProvider)
                    .proposals
                    .canProceed(),
                storyId: storyId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegenerateButton extends ConsumerWidget {
  const _RegenerateButton({required this.storyId});

  final String storyId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      icon: const Icon(
        Icons.autorenew,
        size: 18,
      ),
      onPressed: () {
        ref
            .read(nextAdventureNotifierProvider.notifier)
            .generateNextAdventureProposals(storyId);
      },
      label: Text(context.l10n.regenerate),
    );
  }
}

class _NavigationButtons extends ConsumerWidget {
  const _NavigationButtons({
    required this.storyId,
    required this.canProceed,
  });

  final String storyId;
  final bool canProceed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppButtonBar(
      primaryButton: FilledButton(
        onPressed: canProceed
            ? () => ref
                .read(nextAdventureNotifierProvider.notifier)
                .createNextAdventure(storyId)
            : null,
        child: Text(context.l10n.storyCreatorActionCreate),
      ),
      secondaryButton: OutlinedButton(
        onPressed: () => context.pop(),
        child: Text(context.l10n.storyCreatorActionBack),
      ),
    );
  }
}
