import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/form/model/story_proposal.dart';
import 'package:tale_ai_frontend/form/model/validation.dart';
import 'package:tale_ai_frontend/story_creator/data/data.dart';

const moralInappropriateValidation = Validation(
  message: 'Inappropriate',
  valid: false,
  validationStatus: ValidationStatus.inappropriate,
  suggestedVersion: SuggestedVersion(content: 'Excellent moral'),
);

const moralNeedsImprovementValidation = Validation(
  message: 'Needs improvement',
  valid: true,
  validationStatus: ValidationStatus.needsImprovement,
  suggestedVersion: SuggestedVersion(content: 'Excellent moral'),
);

const moralExcellentValidation = Validation(
  message: 'Excellent',
  valid: true,
  validationStatus: ValidationStatus.excellent,
  suggestedVersion: SuggestedVersion(content: 'Excellent moral'),
);

const mockStoryProposals = [
  StoryProposal(
    title: 'The tale of the brave knight',
    plot: 'Once upon a time, there was a brave knight..',
  ),
  StoryProposal(
    title: 'The tale of the wise wizard',
    plot: 'Once upon a time, there was a wise wizard..',
  ),
  StoryProposal(
    title: 'The tale of the cunning thief',
    plot: 'Once upon a time, there was a cunning thief..',
  ),
];

class FakeStoryCreatorService extends Fake implements StoryCreatorService {
  @override
  Future<String> autofillMoral({required String description}) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return 'AI moral';
  }

  @override
  Future<List<StoryProposal>> createStoryProposals({
    required String? taleDescription,
    required String characterName,
    required String? characterDescription,
    required List<String> suggestions,
  }) {
    return Future.value(mockStoryProposals);
  }

  @override
  Future<Validation> validateMoral({required String description}) {
    if (description == 'inappropriate') {
      return Future.value(moralInappropriateValidation);
    }
    if (description == 'needsImprovement') {
      return Future.value(moralNeedsImprovementValidation);
    }

    return Future.value(moralExcellentValidation);
  }
}
