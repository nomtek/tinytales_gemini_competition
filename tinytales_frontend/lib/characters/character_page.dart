import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/async_value_status.dart';
import 'package:tale_ai_frontend/characters/character_providers.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/extensions.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/story_creator/form/components.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

part 'character_page.g.dart';

@riverpod
AsyncValueStatus _characterScreenState(
  _CharacterScreenStateRef ref,
) {
  final characterState = ref.watch(characterNotifierProvider);
  final error = characterState.error;
  if (error != null && !characterState.isLoading) {
    return AsyncValueStatus.error;
  } else if (error == null && characterState.isLoading) {
    return AsyncValueStatus.loading;
  }
  return AsyncValueStatus.data;
}

@riverpod
({Validation? validation, bool? shouldExitScreen}) _newValidation(
  _NewValidationRef ref,
) {
  final characterPageState = ref.watch(characterNotifierProvider);
  return (
    validation: characterPageState.validation,
    shouldExitScreen: characterPageState.shouldExitScreen
  );
}

enum CharacterPageMode { edit, create }

extension CharacterPageModeX on CharacterPageMode {
  bool isSaveButtonEnabled(CharacterState pageState) {
    switch (this) {
      case CharacterPageMode.edit:
        return !pageState.isAIAutofillInProgress &&
            (pageState.newCharacterName.isNotNullOrBlank &&
                pageState.newCharacterDescription.isNotNullOrBlank) &&
            (pageState.newCharacterName != pageState.initialCharacterName ||
                pageState.newCharacterDescription !=
                    pageState.initialCharacterDescription);
      case CharacterPageMode.create:
        return pageState.newCharacterName.isNotNullOrBlank &&
            pageState.newCharacterDescription.isNotNullOrBlank;
    }
  }
}

class CharacterPage extends HookConsumerWidget {
  const CharacterPage({
    required this.mode,
    this.characterId,
    this.characterName,
    this.characterDescription,
    super.key,
  });

  final CharacterPageMode mode;
  final String? characterId;
  final String? characterName;
  final String? characterDescription;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameTextController = useTextEditingController(
      text: characterName,
    );
    final descriptionTextController = useTextEditingController(
      text: characterDescription,
    );
    final scrollController = useScrollController();
    final isNameInputEnabled = useState(true);
    final isDescriptionInputEnabled = useState(true);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mode == CharacterPageMode.edit) {
            ref.read(characterNotifierProvider.notifier).initEditMode(
                  characterId: characterId,
                  characterName: characterName,
                  characterDescription: characterDescription,
                );
          }
        });
        return null;
      },
      [],
    );

    ref
      // Listen to the state changes of character name and description
      // after state change, and update the text fields accordingly if
      // the values are different, it means that the name and description are
      // updated from the AI autofill button.
      ..listen<CharacterState>(
        characterNotifierProvider,
        (_, nextState) {
          final autofillNameChanged =
              nameTextController.value.text != nextState.newCharacterName &&
                  nextState.newCharacterName.isNotNullOrBlank;
          final autofillDescriptionChanged =
              descriptionTextController.value.text !=
                      nextState.newCharacterDescription &&
                  nextState.newCharacterDescription.isNotNullOrBlank;
          if (autofillNameChanged || autofillDescriptionChanged) {
            semanticsAnnouncement(
              context: context,
              text: context.l10n.a11yCharacterAiAutofillResult(
                nextState.newCharacterName ?? '',
                nextState.newCharacterDescription ?? '',
              ),
            );
          }
          updateTextFieldInChunks(
            controller: nameTextController,
            duration: const Duration(milliseconds: 500),
            value: nextState.newCharacterName,
            context: context,
            onUpdateStart: () => isNameInputEnabled.value = false,
            onUpdateEnd: () => isNameInputEnabled.value = true,
          );

          updateTextFieldInChunks(
            context: context,
            controller: descriptionTextController,
            scrollController: scrollController,
            duration: const Duration(milliseconds: 3000),
            value: nextState.newCharacterDescription,
            onUpdateStart: () => isDescriptionInputEnabled.value = false,
            onUpdateEnd: () => isDescriptionInputEnabled.value = true,
          );
        },
      )
      ..listen(
        characterNotifierProvider,
        (_, nextState) {
          final shouldExitEditScreen = nextState.shouldExitScreen;
          if (shouldExitEditScreen != null && shouldExitEditScreen) {
            context.pop();
          }
        },
      )
      ..listen(_newValidationProvider, (_, next) {
        final validation = next.validation;
        final shouldExitScreen = next.shouldExitScreen;
        if (validation != null && shouldExitScreen != true) {
          announceCharacterInputValidation(
            context: context,
            validation: validation,
          );
        }
      });

    return Scaffold(
      appBar: AppBar(
        title: _CharacterPageTitle(mode: mode),
        actions: [
          if (mode == CharacterPageMode.edit)
            IconButton(
              tooltip: context.l10n.editCharacterPageDeleteButton,
              icon: const Icon(Icons.delete_outlined),
              onPressed: () {
                showConfirmationDialog(
                  context: context,
                  description: context.l10n.deleteCharacterConfirmation,
                  onConfirm: () => ref
                      .read(characterNotifierProvider.notifier)
                      .deleteCharacter(),
                );
              },
            ),
        ],
      ),
      body: AppMaxContentWidth(
        child: Builder(
          builder: (context) {
            switch (ref.watch(_characterScreenStateProvider)) {
              case AsyncValueStatus.error:
                return AppErrorWidget(
                  onTryAgain: () {
                    ref
                        .read(characterNotifierProvider.notifier)
                        .retryErrorAction();
                  },
                  onClose: () {
                    ref.read(characterNotifierProvider.notifier).clearError();
                  },
                );
              case AsyncValueStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case AsyncValueStatus.data:
                return _CharacterForm(
                  mode: mode,
                  nameTextController: nameTextController,
                  descriptionTextController: descriptionTextController,
                  scrollController: scrollController,
                  isDescriptionInputEnabled: isDescriptionInputEnabled.value,
                  isNameInputEnabled: isNameInputEnabled.value,
                  characterId: characterId,
                  characterName: characterName,
                  characterDescription: characterDescription,
                );
            }
          },
        ),
      ),
    );
  }
}

class _CharacterForm extends HookConsumerWidget {
  const _CharacterForm({
    required this.mode,
    required this.nameTextController,
    required this.descriptionTextController,
    required this.scrollController,
    required this.isNameInputEnabled,
    required this.isDescriptionInputEnabled,
    this.characterId,
    this.characterName,
    this.characterDescription,
  });

  final TextEditingController nameTextController;
  final TextEditingController descriptionTextController;
  final ScrollController scrollController;
  final bool isNameInputEnabled;
  final bool isDescriptionInputEnabled;
  final String? characterId;
  final String? characterName;
  final String? characterDescription;

  final CharacterPageMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(characterNotifierProvider);

    return PageHorizontalPadding(
      child: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : AppScrollableContentScaffold(
              scrollableContent: Column(
                children: [
                  if (mode == CharacterPageMode.edit)
                    _CharacterPicture(characterId: characterId!),
                  Gap(context.dimensions.pageVerticalPadding),
                  CharacterInput(
                    nameInputParams: CharacterInputParams(
                      textController: nameTextController,
                      onInputChanged: (value) {
                        ref
                            .read(
                              characterNotifierProvider.notifier,
                            )
                            .setCharacterName(value);
                      },
                      isInputEnabled:
                          isNameInputEnabled && !state.isAIAutofillInProgress,
                    ),
                    descriptionInputParams: DescriptionInputParams(
                      textController: descriptionTextController,
                      scrollController: scrollController,
                      onInputChanged: (value) {
                        ref
                            .read(
                              characterNotifierProvider.notifier,
                            )
                            .setCharacterDescription(value);
                      },
                      isInputEnabled: isDescriptionInputEnabled &&
                          !state.isAIAutofillInProgress,
                    ),
                    isAIAutofillLoading: state.isAIAutofillInProgress,
                    onAIAutofillPressed: () {
                      ref
                          .read(
                            characterNotifierProvider.notifier,
                          )
                          .aiAutofill();
                    },
                    onAutofixPressed: () {
                      final suggestedName =
                          state.validation?.suggestedVersion.name ?? '';

                      final suggestedDescription =
                          state.validation?.suggestedVersion.description ?? '';

                      announceCharacterInputAutofix(
                        context: context,
                        name: suggestedName,
                        description: suggestedDescription,
                      );

                      ref.read(characterNotifierProvider.notifier)
                        ..setCharacterName(suggestedName)
                        ..setCharacterDescription(
                          suggestedDescription,
                        );
                    },
                    validation: state.validation,
                  ),
                ],
              ),
              bottomContent: AppButtonBar(
                primaryButton: FilledButton(
                  onPressed: mode.isSaveButtonEnabled(state)
                      ? () {
                          ref.read(characterNotifierProvider.notifier).save();
                        }
                      : null,
                  child: Text(
                    mode == CharacterPageMode.edit
                        ? context.l10n.editCharacterPageSaveButton
                        : context.l10n.save,
                  ),
                ),
                secondaryButton: OutlinedButton(
                  onPressed: () => context.pop(),
                  child: Text(context.l10n.cancel),
                ),
              ),
            ),
    );
  }
}

class _CharacterPageTitle extends StatelessWidget {
  const _CharacterPageTitle({
    required this.mode,
  });

  final CharacterPageMode mode;

  @override
  Widget build(BuildContext context) {
    return Text(
      mode == CharacterPageMode.edit
          ? context.l10n.editCharacterPageTitle
          : context.l10n.createCharacter,
    );
  }
}

class _CharacterPicture extends HookConsumerWidget {
  const _CharacterPicture({required this.characterId});

  final String characterId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pictureUrl = ref
        .watch(observeCharacterPictureUrlProvider(characterId))
        .asData
        ?.value;

    final pictureState = ref.watch(characterPictureStateProvider(characterId));
    final regenerateEnabled =
        pictureState != AppGeneratedPictureState.generating;

    return Column(
      children: [
        AppLargeGeneratedPicture(
          pictureState: pictureState,
          pictureUrl: pictureUrl,
        ),
        const Gap(8),
        RegenerateButton(
          onPressed: regenerateEnabled
              ? () {
                  ref
                      .read(characterServiceProvider)
                      .regeneratePicture(characterId);
                }
              : null,
        ),
      ],
    );
  }
}
