import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tale_ai_frontend/debug/talker.dart';
import 'package:tale_ai_frontend/extensions.dart';
import 'package:tale_ai_frontend/gen/assets.gen.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/router/router.dart';
import 'package:tale_ai_frontend/story/animation.dart';
import 'package:tale_ai_frontend/story/components/components.dart';
import 'package:tale_ai_frontend/story/data/story.dart';
import 'package:tale_ai_frontend/story/data/story_service.dart';
import 'package:tale_ai_frontend/story/font_size/font_size.dart';
import 'package:tale_ai_frontend/story/providers.dart';
import 'package:tale_ai_frontend/theme/theme.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class StoryPage extends ConsumerWidget {
  const StoryPage({
    required this.storyId,
    this.isModal = false,
    super.key,
  });

  final String storyId;
  final bool isModal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsync = ref.watch(storyProvider(storyId));
    final isInEditMode = ref.watch(isInEditModeProvider);

    ref.listen(audioPlayerVisibilityProvider(storyId), (_, __) {
      // no-op - just to keep it alive with whole page
    });

    final contentWidget = switch (storyAsync) {
      AsyncData(:final value) => value != null
          ? _StoryContent(storyId, isModal: isModal)
          : const _DeletedStoryPlaceholder(),
      AsyncError() => _StoryLoadingError(storyId: storyId),
      AsyncLoading() => const _StoryLoading(),
      AsyncValue<Story?>() =>
        throw StateError('Should not happen in production'),
    };
    final appBar = switch (storyAsync) {
      AsyncData(:final value) => value != null
          ? null
          : AppBar(
              leading: _StoryBackButton(isModal: isModal),
            ),
      AsyncValue<Story?>() => AppBar(
          leading: _StoryBackButton(isModal: isModal),
        ),
    };
    final fab = switch (storyAsync) {
      AsyncData(:final value) => value != null
          ? !context.isDesktopBreakpoint
              ? _StoryFab(storyId: storyId)
              : null
          : null,
      AsyncValue<Story?>() => null,
    };
    final fabLocation = switch (storyAsync) {
      AsyncData() => isInEditMode
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.endContained,
      AsyncValue<Story?>() => null,
    };
    final bottomNav = switch (storyAsync) {
      AsyncData(:final value) => value != null
          ? !context.isDesktopBreakpoint
              ? _BottomBar(storyId: storyId)
              : null
          : null,
      AsyncValue<Story?>() => null,
    };

    return PrimaryScrollController(
      // provide scroll controller so we can
      // easily check if we are at the bottom
      // from any widget in a tree (like Fab button hiding logic)
      controller: ScrollController(),
      child: Scaffold(
        // Added as a solution to minimize the effect of bug
        // https://github.com/flutter/flutter/issues/124205
        // on mobile web.
        resizeToAvoidBottomInset: !isMobileWeb,
        appBar: appBar,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: contentWidget,
        ),
        floatingActionButton: fab,
        floatingActionButtonLocation: fabLocation,
        floatingActionButtonAnimator: StoryFabAnimator(),
        bottomNavigationBar: bottomNav,
      ),
    );
  }
}

class _DeletedStoryPlaceholder extends StatelessWidget {
  const _DeletedStoryPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EmptyList(
          image: Assets.images.historyEmpty.image(),
          title: context.l10n.deletedStoryHeader,
          message: context.l10n.deletedStoryDescription,
          action: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                HomeRoute().go(context);
              },
              child: Text(context.l10n.goBackToHomepage),
            ),
          ),
          shrinkContent: false,
        ),
      ],
    );
  }
}

class _StoryLoading extends StatelessWidget {
  const _StoryLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _StoryLoadingError extends ConsumerWidget {
  const _StoryLoadingError({required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppMaxContentWidth(
      child: AppResponsiveContentPadding(
        child: AppErrorWidget(
          onTryAgain: () => ref.invalidate(storyProvider(storyId)),
          onClose: () => context.pop(),
        ),
      ),
    );
  }
}

class _StoryContent extends StatelessWidget {
  const _StoryContent(
    this.storyId, {
    required this.isModal,
  });

  final String storyId;
  final bool isModal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            controller: PrimaryScrollController.of(context),
            slivers: [
              _StoryAppBar(storyId: storyId, isModal: isModal),
              const SliverGap(10),
              SliverToBoxAdapter(
                child: AppMaxContentWidth(
                  child: AppResponsiveContentPadding(
                    child: PageHorizontalPadding(
                      child: Column(
                        children: [
                          if (context.isDesktopBreakpoint) ...[
                            _ActionsBar(storyId: storyId),
                            const Gap(16),
                          ],
                          _StoryCard(storyId),
                          _CreateNextAdventureButton(storyId: storyId),
                          _StoryEditModeActionButtons(
                            storyId: storyId,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const _BottomSafeSpace(),
            ],
          ),
        ),
        _StoryAudioPlayer(storyId: storyId),
      ],
    );
  }
}

class _CreateNextAdventureButton extends ConsumerWidget {
  const _CreateNextAdventureButton({required this.storyId});

  final String storyId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(nextAdventureNotifierProvider, (prev, next) {
      if (prev == null) return;
      if (prev.error == null &&
          next.error != null &&
          next.error?.action == NextAdventureErrorAction.generateProposals) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.storyPageFailedToGenerateNextAdventure),
          ),
        );
        return;
      }
      final prevProposals = prev.proposals;
      final nextProposals = next.proposals;
      if (prevProposals.storyProposals.isEmpty &&
          nextProposals.storyProposals.isNotEmpty) {
        NextAdventureProposalsRoute(storyId: storyId).go(context);
        return;
      }
    });

    final isInEditMode = ref.watch(isInEditModeProvider);
    if (isInEditMode) return const SizedBox.shrink();

    final proposalsState = ref.watch(nextAdventureNotifierProvider);
    final isEnabled = proposalsState.loadingState == null;

    return AppButtonBar(
      primaryButton: FilledButton.icon(
        icon: isEnabled ? null : const AppButtonLoader(),
        onPressed: isEnabled
            ? () {
                ref
                    .read(nextAdventureNotifierProvider.notifier)
                    .generateNextAdventureProposals(storyId);
              }
            : null,
        label: Text(context.l10n.createNextAdventure),
      ),
    );
  }
}

class _StoryEditModeActionButtons extends ConsumerWidget {
  const _StoryEditModeActionButtons({required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInEditMode = ref.watch(isInEditModeProvider);

    if (!isInEditMode) return const SizedBox.shrink();

    return AppButtonBar(
      primaryButton: OutlinedButton(
        onPressed: () => exitEditMode(ref),
        child: Text(context.l10n.cancel),
      ),
      secondaryButton: FilledButton(
        onPressed: () {
          ref.read(editStoryNotifierProvider.notifier).saveStory(storyId);
          exitEditMode(ref);
        },
        child: Text(context.l10n.storyPageActionSave),
      ),
    );
  }
}

class _StoryAppBar extends ConsumerWidget {
  const _StoryAppBar({
    required this.storyId,
    this.isModal = false,
  });
  final String storyId;
  final bool isModal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      leading: _StoryBackButton(isModal: isModal),
      title: ExcludeSemantics(child: Text(context.l10n.storyPageTitle)),
      // collapsible app bar on scroll
      floating: true,
      actions: context.isDesktopBreakpoint
          ? null
          : [_DeleteStoryButton(storyId: storyId)],
    );
  }
}

class _DeleteStoryButton extends ConsumerWidget {
  const _DeleteStoryButton({
    required this.storyId,
  });

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppIconButton(
      tooltip: context.l10n.storyPageDeleteButton,
      icon: const Icon(Icons.delete_outlined),
      onPressed: () {
        showConfirmationDialog(
          context: context,
          description: context.l10n.deleteStoryConfirmation,
          onConfirm: () => ref.read(storyServiceProvider).deleteStory(storyId),
        ).then((result) {
          if (result == ConfirmationResult.confirm) {
            if (!context.mounted) return;
            ref.read(talkerProvider).info('Story deleted: $storyId');
            // here we do it after dialog is closed
            // to not pop dialog by mistake.
            // pop the page with story and return
            context.pop<StoryPageCloseReason>(StoryPageCloseReason.delete);
          }
        });
      },
    );
  }
}

// In edit mode adds safe area space to the bottom
// to not cover system buttons
// In view model safe area is handled by BottomAppBar
class _BottomSafeSpace extends ConsumerWidget {
  const _BottomSafeSpace();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInEditMode = ref.watch(isInEditModeProvider);
    const minSafeSpace = 30.0;
    return SliverGap(
      isInEditMode
          ? minSafeSpace + MediaQuery.paddingOf(context).bottom
          : minSafeSpace,
    );
  }
}

class _StoryBackButton extends ConsumerWidget {
  const _StoryBackButton({required this.isModal});

  final bool isModal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Widget child;
    if (isInEditMode(ref)) {
      child = Semantics(
        button: true,
        label: context.l10n.storyPageExitEditModeButton,
        child: ExcludeSemantics(
          child: BackButton(
            onPressed: () {
              assert(isInEditMode(ref), 'Should be in edit mode');
              exitEditMode(ref);
            },
          ),
        ),
      );
    } else {
      if (isModal) {
        child = const CloseButton();
      } else {
        child = const BackButton();
      }
    }

    return StoryAnimatedSwitcher(child: child);
  }
}

class _StoryCard extends ConsumerWidget {
  const _StoryCard(this.storyId);

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInEditMode = ref.watch(isInEditModeProvider);

    final content = Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: 16,
        right: 16,
        bottom: 34,
      ),
      child: Column(
        children: [
          _StoryTitle(storyId),
          const Gap(24),
          _StoryPicture(storyId),
          const Gap(24),
          _StoryText(storyId),
        ],
      ),
    );

    const margin = EdgeInsets.zero;
    final elevation = isInEditMode ? 5.0 : 0.0;
    final editModeBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: context.colors.outline),
    );

    return context.isDesktopBreakpoint
        ? Card(
            margin: margin,
            elevation: elevation,
            shape:
                isInEditMode ? editModeBorder : context.theme.cardTheme.shape,
            child: content,
          )
        : Card.outlined(
            margin: margin,
            elevation: elevation,
            shape:
                isInEditMode ? editModeBorder : context.theme.cardTheme.shape,
            child: content,
          );
  }
}

class _ActionsBar extends StatelessWidget {
  const _ActionsBar({required this.storyId});

  final String storyId;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        child: Row(
          children: [
            _ActionsRow(
              storyId: storyId,
            ),
            _DeleteStoryButton(storyId: storyId),
            const Spacer(),
            _StoryFab(storyId: storyId),
          ],
        ),
      ),
    );
  }
}

class _StoryFab extends HookConsumerWidget {
  const _StoryFab({required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInEditMode = ref.watch(isInEditModeProvider);
    final controller = useListenable(PrimaryScrollController.of(context));
    final wasAtBottom = usePrevious(false) ?? false;

    final Widget editButton;
    if (isInEditMode) {
      const bottomThreshold = 150;
      final isAtBottom = !controller.hasClients
          ? wasAtBottom
          : controller.position.maxScrollExtent - controller.position.pixels <
              bottomThreshold;

      editButton = StoryAnimatedSwitcher(
        child: isAtBottom
            ? const SizedBox.shrink()
            : _SaveChangesFab(
                storyId: storyId,
              ),
      );
    } else {
      editButton = const _EnterEditModeFab();
    }

    return StoryAnimatedSwitcher(child: editButton);
  }
}

class _EnterEditModeFab extends ConsumerWidget {
  const _EnterEditModeFab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final button = context.isDesktopBreakpoint
        ? FloatingActionButton.extended(
            // There is a bug in flutter framework with hero animation on
            // fab button and this is workaround for it
            // https://github.com/flutter/flutter/issues/115358
            heroTag: null,
            onPressed: () => enterEditMode(ref),
            elevation: 0,
            icon: const Icon(Icons.mode_edit_outlined),
            label: Text(context.l10n.storyPageEditButton),
          )
        : FloatingActionButton(
            // There is a bug in flutter framework with hero animation on
            // fab button and this is workaround for it
            // https://github.com/flutter/flutter/issues/115358
            heroTag: null,
            onPressed: () => enterEditMode(ref),
            elevation: 0,
            tooltip: context.l10n.storyPageEditButton,
            child: const Icon(Icons.mode_edit_outlined),
          );

    return Semantics(
      button: true,
      label: context.l10n.storyPageEditButton,
      child: ExcludeSemantics(
        child: button,
      ),
    );
  }
}

class _SaveChangesFab extends ConsumerWidget {
  const _SaveChangesFab({
    required this.storyId,
  });

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      // There is a bug in flutter framework with hero animation on
      // fab button and this is workaround for it
      // https://github.com/flutter/flutter/issues/115358
      heroTag: null,
      onPressed: () {
        ref.read(editStoryNotifierProvider.notifier).saveStory(storyId);
        exitEditMode(ref);
      },
      label: Text(context.l10n.storyPageActionSave),
      icon: const Icon(Icons.check_outlined),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInEditMode = ref.watch(isInEditModeProvider);
    final bottomAppBar = BottomAppBar(
      child: _ActionsRow(storyId: storyId),
    );

    return AnimatedContainer(
      duration: editModeAnimDuration,
      curve: editModeAnimCurve,
      height: isInEditMode ? 0 : 80 + MediaQuery.paddingOf(context).bottom,
      child: bottomAppBar,
    );
  }
}

class _ActionsRow extends ConsumerWidget {
  const _ActionsRow({
    required this.storyId,
  });

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Row(
        children: [
          if (!kIsWeb) _ShareStoryButton(storyId: storyId),
          _AudioActionButton(storyId: storyId),
          const _ChageFontSizeButton(),
          _GeneratePdfButton(storyId: storyId),
        ],
      ),
    );
  }
}

class _ChageFontSizeButton extends ConsumerWidget {
  const _ChageFontSizeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppIconButton(
      tooltip: context.l10n.storyPageChangeFontSizeButton,
      onPressed: () async {
        final size = await _StoryTextSizeSelectionDialog.show(
          context,
          currentSize: ref.read(storyTextSizeNotifierProvider),
        );
        if (size != null) {
          await ref
              .read(storyTextSizeNotifierProvider.notifier)
              .changeFontSize(size);
        }
      },
      icon: const Icon(Icons.format_size_outlined),
    );
  }
}

class _ShareStoryButton extends ConsumerWidget {
  const _ShareStoryButton({
    required this.storyId,
  });

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppIconButton(
      tooltip: context.l10n.storyPageShareButton,
      onPressed: () async {
        final text = ref.read(storyTextProvider(storyId));
        final result = await Share.share(text);
        if (!context.mounted) return;
        switch (result.status) {
          case ShareResultStatus.success:
            ref.read(talkerProvider).info('Story shared');
          case ShareResultStatus.dismissed:
            ref.read(talkerProvider).info('Story share dismissed');
          case ShareResultStatus.unavailable:
            ref.read(talkerProvider).info('Story share unavailable');
        }
      },
      icon: const Icon(Icons.share_outlined),
    );
  }
}

// handles requesting audio generation
// and showing audio player
class _AudioActionButton extends ConsumerWidget {
  const _AudioActionButton({
    required this.storyId,
  });

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioProvider = audioGenerationNotifierProvider(storyId);
    final generationState = ref.watch(audioProvider);

    ref.listen(audioProvider, (prev, next) {
      if (prev is! AudioReady && next is AudioReady) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.storyPageGeneratedAudioDescription),
          ),
        );
        ref.read(audioPlayerVisibilityProvider(storyId).notifier).show();
        return;
      }

      if (prev is! AudioError && next is AudioError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.storyPageAudioError)),
        );
        return;
      }
    });

    const iconWeight = 600.0;
    const buttonIcon = Icon(Symbols.auto_read_play, weight: iconWeight);
    const buttonIconSelected =
        Icon(Symbols.auto_read_play, fill: 1, weight: iconWeight);

    final audioPlayerVisible =
        ref.watch(audioPlayerVisibilityProvider(storyId));

    final audioReadyText = audioPlayerVisible
        ? context.l10n.storyPageClosePlayerButton
        : context.l10n.storyPageOpenPlayerButton;

    switch (generationState) {
      case AudioInit():
      case AudioError():
        return AppIconButton(
          tooltip: context.l10n.storyPageGenerateAudioButton,
          onPressed: () {
            ref
                .read(audioGenerationNotifierProvider(storyId).notifier)
                .generateAudio();
          },
          icon: buttonIcon,
        );
      case AudioGenerating():
        return IconButtonLoader(
          tooltip: context.l10n.storyPageGeneratingAudioDescription,
        );
      case AudioReady():
        return AppIconButton(
          tooltip: audioReadyText,
          isSelected: audioPlayerVisible,
          onPressed: () {
            ref.read(audioPlayerVisibilityProvider(storyId).notifier).toggle();
          },
          icon: buttonIcon,
          selectedIcon: buttonIconSelected,
        );
      case NoAudio():
        return const SizedBox.shrink();
    }
  }
}

class _GeneratePdfButton extends ConsumerWidget {
  const _GeneratePdfButton({
    required this.storyId,
  });

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPdfGenerating = ref.watch(isPdfGeneratingProvider(storyId));

    final Widget button;
    if (!isPdfGenerating) {
      button = AppIconButton(
        tooltip: context.l10n.storyPageOpenPdfButton,
        onPressed: () async {
          final log = ref.read(talkerProvider)
            ..info('Generate pdf button pressed');
          final pdfUrl = ref.read(storyPdfUrlProvider(storyId));

          Future<void> launchPdf(String pdfUrl) async {
            try {
              log.info('pdf url exists');
              final uri = Uri.tryParse(pdfUrl);
              if (uri != null) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
                return;
              } else {
                log.error('Failed to parse download url');
                throw Exception('Failed to parse download url');
              }
            } catch (e, st) {
              log.error('failed to download pdf', e, st);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.storyPageFailedToDownloadPdf),
                ),
              );
            }
          }

          if (pdfUrl != null) {
            await launchPdf(pdfUrl);
            return;
          }
          final pdfGenState = ref.watch(generateStoryPdfNotifierProvider);
          final shouldGenerate = pdfGenState == GeneratePdfState.init;
          if (shouldGenerate) {
            log.info('request pdf generation');
            try {
              final url = await ref
                  .read(generateStoryPdfNotifierProvider.notifier)
                  .generatePdf(storyId: storyId);
              if (!context.mounted) return;
              await launchPdf(url);
            } catch (e, st) {
              log.error('failed to generate pdf', e, st);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.storyPageFailedToGeneratePdf),
                ),
              );
            }
            return;
          }

          assert(
            pdfUrl == null || shouldGenerate,
            'Button should be disabled when pdf is being generated',
          );
        },
        icon: const Icon(Icons.picture_as_pdf_outlined),
      );
    } else {
      button = IconButtonLoader(
        tooltip: context.l10n.storyPageGeneratingPdfDescription,
      );
    }

    return AnimatedSwitcher(duration: Durations.short3, child: button);
  }
}

/// Loader for IconButton.
/// Should match size of IconButton.
/// Use to show loading state for IconButton.
class IconButtonLoader extends StatelessWidget {
  const IconButtonLoader({
    required this.tooltip,
    super.key,
  });

  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: tooltip,
      child: const SizedBox.square(
        dimension: 48,
        child: Padding(
          // 48 is size of IconButton
          // which most of the time has icon with 24x24 size
          // which gives us 12 padding on each side
          // it's to match other buttons
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _StoryTitle extends ConsumerWidget {
  const _StoryTitle(this.storyId);

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      header: true,
      child: HeadlineSmallText(title: ref.watch(storyTitleProvider(storyId))),
    );
  }
}

class _StoryPicture extends HookConsumerWidget {
  const _StoryPicture(this.storyId);

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pictureUrl = ref.watch(storyPictureUrlProvider(storyId));
    final pictureState = ref.watch(storyPictureStateProvider(storyId));

    final regenerateEnabled =
        pictureState != AppGeneratedPictureState.generating;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 400,
            maxWidth: 400,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: context.colors.surfaceContainerHighest,
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: AppGeneratedPicture(
                    pictureUrl: pictureUrl,
                    pictureState: pictureState,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Gap(8),
        RegenerateButton(
          onPressed: regenerateEnabled
              ? () {
                  ref.read(storyServiceProvider).regeneratePicture(storyId);
                }
              : null,
        ),
      ],
    );
  }
}

class _StoryText extends HookConsumerWidget {
  const _StoryText(this.storyId);

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyText = ref.watch(storyTextProvider(storyId));
    final isInEditMode = ref.watch(isInEditModeProvider);
    final textController = useTextEditingController(text: storyText);

    useEffect(
      () {
        textController.text = storyText;
        return null;
      },
      [isInEditMode, storyText],
    );
    ref.watch(editStoryNotifierProvider);

    return TextField(
      readOnly: !isInEditMode,
      controller: textController,
      maxLines: null,
      onChanged: (text) {
        ref.read(editStoryNotifierProvider.notifier).editStory(text);
      },
      style: context.textTheme.bodyMedium?.copyWith(
        fontSize: ref.watch(storyTextSizeNotifierProvider).fontSize,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}

/// Dialog for selecting text size.
/// Use [_StoryTextSizeSelectionDialog.show] to show it.
class _StoryTextSizeSelectionDialog extends HookWidget {
  const _StoryTextSizeSelectionDialog({
    required this.initialSize,
  });

  final StoryTextSize initialSize;

  @override
  Widget build(BuildContext context) {
    final selected = useState(initialSize);

    return AlertDialog(
      icon: const Icon(Icons.format_size_outlined),
      title: Text(context.l10n.storyPageFontSizeDialogTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.storyPageFontSizeDialogDescription),
            const Gap(24),
            for (final option in StoryTextSize.values) ...[
              Semantics(
                button: true,
                label: option.a11yLabel(context),
                selected: selected.value == option,
                child: ExcludeSemantics(
                  child: RadioListTile<StoryTextSize>(
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.zero,
                    value: option,
                    groupValue: selected.value,
                    title: Text(option.label(context)),
                    onChanged: (value) => selected.value = value!,
                  ),
                ),
              ),
              if (option != StoryTextSize.values.last)
                Divider(
                  indent: context.theme.dialogTheme.insetPadding?.left,
                  endIndent: context.theme.dialogTheme.insetPadding?.right,
                ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(selected.value),
          child: Text(MaterialLocalizations.of(context).saveButtonLabel),
        ),
      ],
    );
  }

  static Future<StoryTextSize?> show(
    BuildContext context, {
    required StoryTextSize currentSize,
  }) async {
    return showDialog<StoryTextSize>(
      context: context,
      builder: (context) => _StoryTextSizeSelectionDialog(
        initialSize: currentSize,
      ),
    );
  }
}

class _StoryAudioPlayer extends HookConsumerWidget {
  const _StoryAudioPlayer({
    required this.storyId,
  });

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(storyTitleProvider(storyId));
    final audioUrl = ref.watch(storyAudioUrlProvider(storyId));
    final isVisible = ref.watch(audioPlayerVisibilityProvider(storyId));
    final effectiveVisibility = audioUrl != null && isVisible;

    return effectiveVisibility
        ? UrlAudioPlayer(
            title: title,
            audioUrl: audioUrl,
            onClose: () {
              ref
                  .read(audioPlayerVisibilityProvider(storyId).notifier)
                  .toggle();
            },
          )
        : const SizedBox.shrink();
  }
}
