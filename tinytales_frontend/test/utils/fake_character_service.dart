import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/form/form.dart';

const characterInappropriateValidation = Validation(
  valid: false,
  validationStatus: ValidationStatus.inappropriate,
  message: 'Inappropriate',
  suggestedVersion: SuggestedVersion(
    name: 'Suggested: Name ',
    description: 'Suggested: Description',
  ),
);

const characterNeedsImprovementValidation = Validation(
  valid: true,
  validationStatus: ValidationStatus.needsImprovement,
  message: 'Needs improvement',
  suggestedVersion: SuggestedVersion(
    name: 'Suggested: Name ',
    description: 'Suggested: Description',
  ),
);

const characterExcellentValidation = Validation(
  valid: true,
  validationStatus: ValidationStatus.excellent,
  suggestedVersion: SuggestedVersion(
    name: 'Suggested: Name ',
    description: 'Suggested: Description',
  ),
);

class FakeCharacterService extends Fake implements CharacterService {
  FakeCharacterService({
    Validation? validation,
  }) : validation = validation ?? characterExcellentValidation;

  Validation validation;

  @override
  Future<AutofillCharacter> autofillCharacter({
    required String name,
    required String description,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return const AutofillCharacter(
      name: 'AI Name',
      description: 'AI Description',
    );
  }

  @override
  Future<Validation> validateCharacter({
    required String name,
    required String description,
  }) async {
    return validation;
  }
}
