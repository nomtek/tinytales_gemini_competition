import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';

part 'story_creator_service.g.dart';

@riverpod
StoryCreatorService storyCreatorService(StoryCreatorServiceRef ref) {
  final functions = ref.watch(firebaseFunctionsProvider);
  return StoryCreatorService(functions);
}

// It's intentional that we do not have any abstraction between Firebase
// and the service, as we are not sure how the service will evolve.
// Service is a good enough abstraction for now.
// More abstraction can be added when we actually need it.
class StoryCreatorService {
  StoryCreatorService(this._functions);

  final FirebaseFunctions _functions;

  /// Autofills a moral with the given [description].
  ///
  /// Returns the autofilled moral (enriched description).
  Future<String> autofillMoral({required String description}) async {
    final result = await _functions.callJson(
      'autofillMoral',
      params: {_descriptionProp: description},
    );
    return result.data[_descriptionProp] as String;
  }

  Future<List<StoryProposal>> createStoryProposals({
    required String? taleDescription,
    required String characterName,
    required String? characterDescription,
    required List<String> suggestions,
  }) async {
    final result = await _functions.callJson(
      'createProposals',
      params: {
        'taleDescription': taleDescription,
        'characterName': characterName,
        'characterDescription': characterDescription,
        _suggestionsProp: suggestions,
      },
    );

    final proposals = StoryProposals.fromJson(result.data).proposals;

    return proposals;
  }

  Future<Validation> validateMoral({
    required String description,
  }) {
    final result = _functions.callJson(
      'validateMoral',
      params: {
        _descriptionProp: description,
      },
    );

    final validation = result.then((result) {
      return Validation.fromJson(result.data);
    });

    return validation;
  }

  Future<String> createStory({
    required String moral,
    required String characterName,
    required List<StoryProposal> proposals,
    required int chosenProposalIndex,
    required StoryLength storyLength,
    required List<String> suggestions,
    String? characterDescription,
  }) async {
    final result = await _functions.callJson(
      'createTale',
      params: {
        'moral': moral,
        'characterName': characterName,
        'characterDescription': characterDescription,
        'proposals': proposals.map((e) => e.toJson()).toList(),
        'chosenProposalIndex': chosenProposalIndex,
        'storyLength': storyLength.toJson(),
        _suggestionsProp: suggestions,
      },
    );
    return result.data['taleId'] as String;
  }
}

extension _StoryLengthJsonX on StoryLength {
  String toJson() {
    switch (this) {
      case StoryLength.short:
        return 'short';
      case StoryLength.medium:
        return 'medium';
      case StoryLength.long:
        return 'long';
    }
  }
}

const _descriptionProp = 'description';
const _suggestionsProp = 'suggestions';
