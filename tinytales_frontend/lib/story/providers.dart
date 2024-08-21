// ignore_for_file: avoid_redundant_argument_values

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/debug/talker.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/story/data/data.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

part 'providers.g.dart';

final isInEditModeProvider = StateProvider.autoDispose<bool>((ref) => false);

bool isInEditMode(WidgetRef ref) => ref.watch(isInEditModeProvider);

void enterEditMode(WidgetRef ref) {
  ref.read(isInEditModeProvider.notifier).state = true;
}

void exitEditMode(WidgetRef ref) {
  ref.read(isInEditModeProvider.notifier).state = false;
}

@riverpod
Stream<Story?> story(StoryRef ref, String storyId) =>
    ref.watch(storyServiceProvider).observeStory(storyId);

@riverpod
String? storyPdfUrl(StoryPdfUrlRef ref, String storyId) {
  final storyAsync = ref.watch(storyProvider(storyId));
  switch (storyAsync) {
    case AsyncData(:final value):
      return value?.pdfUrl;
    case AsyncValue<Story?>():
      return null;
  }
}

enum GeneratePdfState {
  init,
  generating,
  generationCompleted,
}

@riverpod
class GenerateStoryPdfNotifier extends _$GenerateStoryPdfNotifier {
  GenerateStoryPdfNotifier();

  @override
  GeneratePdfState build() => GeneratePdfState.init;

  Future<String> generatePdf({required String storyId}) async {
    try {
      assert(
        state != GeneratePdfState.generating,
        'We are already generating pdf',
      );
      final pdfUrl = ref.read(storyPdfUrlProvider(storyId));
      if (pdfUrl != null) {
        // pdf already exists so generation was completed
        state = GeneratePdfState.generationCompleted;
        return pdfUrl;
      }

      state = GeneratePdfState.generating;

      final generatedUrl =
          await ref.read(storyServiceProvider).generatePdf(storyId);
      // we don't set generation completed here as we need to wait for the
      // pdf url to be available
      state = GeneratePdfState.generationCompleted;
      return generatedUrl;
    } catch (e, st) {
      ref.read(talkerProvider).error('Failed to generate pdf', e, st);
      // reset to be able to retry
      state = GeneratePdfState.init;
      // so the calling site can react to the error
      rethrow;
    }
  }
}

@riverpod
bool isPdfGenerating(IsPdfGeneratingRef ref, String storyId) {
  final pdfUrl = ref.watch(storyPdfUrlProvider(storyId));
  if (pdfUrl != null && pdfUrl.isNotEmpty) {
    return false;
  }
  final generationState = ref.watch(generateStoryPdfNotifierProvider);
  return generationState == GeneratePdfState.generating;
}

@riverpod
String storyTitle(StoryTitleRef ref, String storyId) {
  final storyAsync = ref.watch(storyProvider(storyId));
  switch (storyAsync) {
    case AsyncData(:final value):
      return value?.title ?? '';
    case AsyncValue<Story?>():
      return '';
  }
}

@riverpod
String storyPictureUrl(StoryPictureUrlRef ref, String storyId) {
  final storyAsync = ref.watch(storyProvider(storyId));
  switch (storyAsync) {
    case AsyncData(:final value):
      return value?.picture?.toString() ?? '';
    case AsyncValue<Story?>():
      return '';
  }
}

@riverpod
AppGeneratedPictureState storyPictureState(
  StoryPictureStateRef ref,
  String storyId,
) {
  final storyAsync = ref.watch(storyProvider(storyId));
  switch (storyAsync) {
    case AsyncLoading():
      return AppGeneratedPictureState.generating;
    case AsyncData(:final value):
      return switch (value?.pictureState) {
        PictureState.pageIllustrationGeneration =>
          AppGeneratedPictureState.generating,
        null => AppGeneratedPictureState.generating,
        PictureState.completed => AppGeneratedPictureState.generationCompleted,
        PictureState.error => AppGeneratedPictureState.error,
      };
    case AsyncValue<Story?>():
      return AppGeneratedPictureState.error;
  }
}

@riverpod
String storyText(StoryTextRef ref, String storyId) {
  final storyAsync = ref.watch(storyProvider(storyId));
  switch (storyAsync) {
    case AsyncData(:final value):
      // Backend sends us text state based on which we can
      // decide if we should show full text or not
      // but intentionally we don't use it here.
      // We just show full text or empty string in case it's missing.
      return value?.fullText ?? '';
    case AsyncValue<Story?>():
      return '';
  }
}

@riverpod
class EditStoryNotifier extends _$EditStoryNotifier {
  @override
  String build() => '';

  // ignore: use_setters_to_change_properties
  void editStory(String editedText) {
    state = editedText;
  }

  void saveStory(String storyId) {
    if (state.isEmpty) {
      return;
    }
    ref.read(storyServiceProvider).updateStory(storyId, state);
  }
}

@riverpod
String? storyAudioUrl(StoryAudioUrlRef ref, String storyId) {
  final storyAsync = ref.watch(storyProvider(storyId));
  final url = storyAsync.valueOrNull?.audioUrl;
  return url;
}

@riverpod
class AudioGenerationNotifier extends _$AudioGenerationNotifier {
  AudioGenerationNotifier();

  @override
  AudioGenerationState build(String storyId) {
    final storyAsync = ref.watch(storyProvider(storyId));
    switch (storyAsync) {
      case AsyncLoading():
        return AudioInit();
      case AsyncData(:final value):
        if (value == null) {
          // story is not created yet or was deleted
          return NoAudio();
        }
        final audioUrl = value.audioUrl;

        if (audioUrl != null && audioUrl.isNotEmpty) {
          // shortcut +
          // can fix problems when url is out of sync with audio state
          return AudioReady(audioUrl);
        }
        return switch (value.audioState) {
          AudioState.noAudio => AudioInit(),
          AudioState.audioGeneration => AudioGenerating(),
          AudioState.audioReview => AudioGenerating(),
          AudioState.completed => () {
              // workaround until audio url is stored in the story object
              final url = audioUrl;
              if (url == null || url.isEmpty) {
                return NoAudio();
              } else {
                return AudioReady(url);
              }
            }.call(),
          AudioState.error => () {
              ref.read(talkerProvider).info('Failed to generate audio');
              return AudioError('Failed to generate audio');
            }(),
          null => AudioInit(),
        };
      case AsyncError(:final error, :final stackTrace):
        ref.read(talkerProvider).error(
              'Failed to load story',
              error,
              stackTrace,
            );
        return AudioError('Failed to load story');
      case AsyncValue<Story>():
        ref.read(talkerProvider).error('Failed to load story');
        return AudioError('Failed to load story');
    }
    // should never happen - added to satisfy the linter
    throw StateError('Unreachable - audio generation state not handled');
  }

  Future<void> generateAudio() async {
    ref.read(talkerProvider).info('Audio generation started');
    try {
      // generating is set here to prevent multiple generations
      // and to show the loading indicator immediately
      state = AudioGenerating();
      await ref.read(storyServiceProvider).generateAudio(storyId);
      ref.read(talkerProvider).info('Audio generation completed');
      // we don't set generation completed here as we need to wait for the
      // audio url to be available in the story object.
      // may lead to infinite loading
    } catch (e, st) {
      ref.read(talkerProvider).error('Failed to generate audio', e, st);
      // same goes for error - we wait for error state
      // to be set in the story object
    }
  }
}

// Represents the state of the audio generation process.
sealed class AudioGenerationState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class AudioInit extends AudioGenerationState {}

class AudioGenerating extends AudioGenerationState {}

class AudioReady extends AudioGenerationState {
  AudioReady(this.url);

  final String url;

  @override
  List<Object?> get props => [url];

  @override
  bool? get stringify => true;
}

class AudioError extends AudioGenerationState {
  AudioError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  bool? get stringify => true;
}

// story has no audio at all
// special case when audio is not set
// but it states it's generated
class NoAudio extends AudioGenerationState {}

@riverpod
class AudioPlayerVisibility extends _$AudioPlayerVisibility {
  AudioPlayerVisibility();

  @override
  bool build(String storyId) => false;

  void toggle() {
    state = !state;
  }

  void show() {
    state = true;
  }
}

@riverpod
class NextAdventureNotifier extends _$NextAdventureNotifier
    with RetryErrorAction {
  @override
  NextAdventureState build() {
    return NextAdventureState.initial();
  }

  Future<void> generateNextAdventureProposals(
    String storyId,
  ) async {
    final oldProposals = state.proposals;
    state = state
        .copyWith(
          proposals: const ProposalsViewState(),
          error: null,
        )
        .withLoadingState(LoadingState.loading);
    try {
      final proposals = await ref
          .read(storyServiceProvider)
          .createNextAdventureProposals(taleId: storyId);
      assert(
        proposals.isNotEmpty,
        'No proposals generated for the story',
      );
      state = state.copyWith(
        loadingState: null,
        proposals: ProposalsViewState(
          storyProposals: proposals,
          selectedProposalIndex: null,
        ),
      );
    } catch (e, st) {
      ref
          .read(talkerProvider)
          .error('Failed to generate next adventure proposals', e, st);
      state = state.copyWith(
        loadingState: null,
        proposals: oldProposals,
        error: NextAdventureError(
          action: NextAdventureErrorAction.generateProposals,
          error: e.toString(),
          storyId: storyId,
        ),
      );
    }
  }

  void setStoryProposal(StoryProposal proposal) {
    assert(
      state.loadingState == null,
      'Cannot set story proposal when loading',
    );
    assert(
      state.error == null,
      'Cannot set story proposal when error',
    );
    state = state.copyWith(
      proposals: state.proposals.copyWith(
        selectedProposalIndex: state.proposals.storyProposals.indexOf(proposal),
      ),
    );
  }

  Future<void> createNextAdventure(String storyId) async {
    try {
      assert(
        state.loadingState == null,
        'Cannot create next adventure when loading',
      );
      assert(
        state.proposals.selectedProposalIndex != null,
        'Cannot create next adventure without selected proposal',
      );
      assert(
        state.error == null,
        'Cannot create next adventure when error',
      );
      state = state.withLoadingState(LoadingState.creatingStory);
      final nextAdventureId =
          await ref.read(storyServiceProvider).createNextAdventure(
                originalStoryId: storyId,
                proposals: state.proposals.storyProposals,
                chosenProposalIndex: state.proposals.selectedProposalIndex!,
              );

      state = state.copyWith(
        loadingState: null,
        nextAdventureId: nextAdventureId,
      );
    } catch (e, st) {
      ref.read(talkerProvider).error('Failed to create next adventure', e, st);
      state = state.copyWith(
        loadingState: null,
        error: NextAdventureError(
          action: NextAdventureErrorAction.createNextAdventure,
          error: e.toString(),
          storyId: storyId,
        ),
      );
    }
  }

  @override
  Future<void> retryErrorAction() async {
    final error = state.error;
    if (error == null) return;
    switch (error.action) {
      case NextAdventureErrorAction.generateProposals:
        await generateNextAdventureProposals(error.storyId);
      case NextAdventureErrorAction.createNextAdventure:
        await createNextAdventure(error.storyId);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

@riverpod
String? nextAdventureId(NextAdventureIdRef ref) {
  final nextAdventureState = ref.watch(nextAdventureNotifierProvider);
  return nextAdventureState.nextAdventureId;
}

@CopyWith()
class NextAdventureState with EquatableMixin {
  NextAdventureState({
    required this.loadingState,
    required this.error,
    required this.proposals,
    this.nextAdventureId,
  });

  factory NextAdventureState.initial() {
    return NextAdventureState(
      loadingState: null,
      error: null,
      proposals: const ProposalsViewState(),
    );
  }

  /// When null there is no loading.
  /// When not null it indicates what is being loaded.
  final LoadingState? loadingState;
  final NextAdventureError? error;
  final ProposalsViewState proposals;
  final String? nextAdventureId;

  @override
  List<Object?> get props => [
        loadingState,
        error,
        proposals,
        nextAdventureId,
      ];
}

enum LoadingState {
  loading,
  creatingStory,
}

class NextAdventureError with EquatableMixin {
  NextAdventureError({
    required this.action,
    required this.storyId,
    this.error,
  });

  final NextAdventureErrorAction action;
  final String? error;
  final String storyId;

  @override
  List<Object?> get props => [action, error, storyId];
}

enum NextAdventureErrorAction {
  generateProposals,
  createNextAdventure,
}

enum NextAdventureScreenStatus {
  loading,
  data,
  error,
}

extension NextAdventureStateX on NextAdventureState {
  NextAdventureScreenStatus get screenStatus {
    if (error == null && loadingState != null) {
      return NextAdventureScreenStatus.loading;
    }
    if (error != null && loadingState == null) {
      return NextAdventureScreenStatus.error;
    }
    return NextAdventureScreenStatus.data;
  }

  /// Sets loading state and clears error
  NextAdventureState withLoadingState(LoadingState? loadingState) {
    return copyWith(loadingState: loadingState, error: null);
  }
}
