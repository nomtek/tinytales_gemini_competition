import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/story/story.dart';
import 'package:tale_ai_frontend/story_creator/story_creator.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

import '../../utils/utils.dart';
import '../test_extension.dart';
import 'story_creator_test_utils.dart';

void main() {
  group('StoryCreatorPage character step', () {
    testWidgets(
      'After completing length step character step is displayed',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.empty(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        expect(find.byType(StoryCreatorCharacterStep), findsOneWidget);
      },
    );

    testWidgets(
      'If user has no characters, character creation substep is displayed',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.empty(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        expect(
          find.byType(StoryCreatorCharacterCreationSubstep),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'If user has no characters, '
      'and will tap go back, length step is displayed',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.empty(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await tapBackButtonAndPump(tester);
        expect(find.byType(StoryCreatorLengthStep), findsOneWidget);
      },
    );

    testWidgets(
      'If user has characters, character selection substep is displayed',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        expect(
          find.byType(StoryCreatorCharacterSelectionSubstep),
          findsOneWidget,
        );
      },
    );

    testWidgets(
        'If user has characters, '
        'and will tap go back on character selection substep, '
        'length step is displayed', (tester) async {
      await pumpTestAppWithStoryCreatorPage(
        tester: tester,
        overrides: [
          charactersServiceProvider.overrideWith(
            (ref) => FakeCharactersService.withFakeCharacters(),
          ),
          storyServiceProvider.overrideWith(
            (ref) => FakeStoryService(),
          ),
        ],
      );
      await goThruLengthStep(tester);
      expect(
        find.byType(StoryCreatorCharacterSelectionSubstep),
        findsOneWidget,
      );
      await tapBackButtonAndPump(tester);
      expect(find.byType(StoryCreatorCharacterStep), findsNothing);
      expect(find.byType(StoryCreatorLengthStep), findsOneWidget);
    });

    testWidgets(
      'If user has characters, '
      'and will tap create new character, '
      'character creation substep is displayed',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        expect(
          find.byType(StoryCreatorCharacterSelectionSubstep),
          findsOneWidget,
        );
        await tester.tap(find.byType(CustomStepTile));
        await tester.pumpAndSettle();
        expect(
          find.byType(StoryCreatorCharacterCreationSubstep),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'If user on character selection substep did not select any character, '
      'next button should be disabled',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        expect(
          find.byType(StoryCreatorCharacterSelectionSubstep),
          findsOneWidget,
        );
        final button = findStoryCreatorNextButton(tester);
        expect(button.enabled, false);
      },
    );

    testWidgets(
      'If user on character selection substep selected any character, '
      'next button should be enabled',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        expect(
          find.byType(StoryCreatorCharacterSelectionSubstep),
          findsOneWidget,
        );
        await tester.tap(find.byType(SelectableCharacterTile).first);
        await tester.pumpAndSettle();
        expect(findStoryCreatorNextButton(tester).enabled, true);
      },
    );

    testWidgets(
      'If user on character creation substep '
      'did not enter any name or description '
      'next button should be disabled',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        expect(findStoryCreatorNextButton(tester).enabled, false);
      },
    );

    testWidgets(
      'If user on character creation substep '
      'entered  just name '
      'next button should be disabled',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        await tester.enterText(
          find.byKey(CharacterInput.nameInputKey),
          'Name',
        );
        await tester.pumpAndSettle();
        expect(findStoryCreatorNextButton(tester).enabled, false);
      },
    );

    testWidgets(
      'If user on character creation substep '
      'entered  just description '
      'next button should be disabled',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        await tester.enterText(
          find.byKey(CharacterInput.descriptionInputKey),
          'Description',
        );
        await tester.pumpAndSettle();
        expect(findStoryCreatorNextButton(tester).enabled, false);
      },
    );

    testWidgets(
      'If user on character creation substep '
      'entered whitespace name and description '
      'next button should be disabled',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        await tester.enterText(
          find.byKey(CharacterInput.nameInputKey),
          '      ',
        );
        await tester.enterText(
          find.byKey(CharacterInput.descriptionInputKey),
          '    ',
        );
        await tester.pumpAndSettle();
        expect(findStoryCreatorNextButton(tester).enabled, false);
      },
    );

    testWidgets(
      'If user on character creation substep '
      'entered  name and description '
      'next button should be enabled',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        await tester.enterText(
          find.byKey(CharacterInput.nameInputKey),
          'Name',
        );
        await tester.enterText(
          find.byKey(CharacterInput.descriptionInputKey),
          'Description',
        );
        await tester.pumpAndSettle();
        expect(findStoryCreatorNextButton(tester).enabled, true);
      },
    );
    testWidgets(
      'If user on character creation substep '
      'pressed autofill button '
      'next button should be disabled until autofill is completed',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            characterServiceProvider.overrideWith(
              (ref) => FakeCharacterService(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        await tester.tap(find.byType(AiAutofillButton));
        await tester.pump();
        expect(findStoryCreatorNextButton(tester).enabled, false);
        await tester.pump(const Duration(seconds: 3));
        expect(findStoryCreatorNextButton(tester).enabled, true);
      },
    );

    testWidgets(
      'If user on character creation substep '
      'pressed autofill button '
      'AiAutofill button should be disabled until autofill is completed',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            characterServiceProvider.overrideWith(
              (ref) => FakeCharacterService(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
          ],
        );

        await goThruLengthStep(tester);
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        await tester.tap(find.byType(AiAutofillButton));
        await tester.pump();
        expect(
          tester
              .widget<AiAutofillButton>(find.byType(AiAutofillButton))
              .enabled,
          false,
        );
        // Wait for AI autofill result is displayed on the screen
        await tester.pump(const Duration(seconds: 3));
        expect(
          tester
              .widget<AiAutofillButton>(find.byType(AiAutofillButton))
              .enabled,
          true,
        );
      },
    );
    testWidgets(
      'If user puts inappropriate character input '
      'must stay on character step after pressing next button',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
            characterServiceProvider.overrideWith(
              (ref) => FakeCharacterService(
                validation: characterInappropriateValidation,
              ),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        await fillCharacterInputsWithInappropriateValues(tester);
        await tapNextButtonAndPump(tester);
        expect(find.byType(StoryCreatorCharacterStep), findsOneWidget);
      },
    );

    testWidgets(
      'If user puts inappropriate character input '
      'then get validation warning '
      'and press next button without any changes '
      'must stay on character step after pressing next button',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
            characterServiceProvider.overrideWith(
              (ref) => FakeCharacterService(
                validation: characterInappropriateValidation,
              ),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        await fillCharacterInputsWithInappropriateValues(tester);
        await tapNextButtonAndPump(tester);
        expect(
          find.byType(StoryCreatorCharacterCreationSubstep),
          findsOneWidget,
        );
        await tapNextButtonAndPump(tester);
        expect(
          find.byType(StoryCreatorCharacterCreationSubstep),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'If user puts inappropriate character input '
      'validation message must be displayed after pressing next button',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
            characterServiceProvider.overrideWith(
              (ref) => FakeCharacterService(
                validation: characterInappropriateValidation,
              ),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        await fillCharacterInputsWithInappropriateValues(tester);
        await tapNextButtonAndPump(tester);
        expect(
          find.widgetWithText(
            ValidationTextField,
            characterInappropriateValidation.message!,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'If user puts character input that needs improvement '
      'must stay on character step after pressing next button',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
            characterServiceProvider.overrideWith(
              (ref) => FakeCharacterService(
                validation: characterNeedsImprovementValidation,
              ),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        await fillCharacterInputsWithNeedsImprovementValues(tester);
        await tapNextButtonAndPump(tester);
        expect(find.byType(StoryCreatorCharacterStep), findsOneWidget);
      },
    );

    testWidgets(
      'If user puts character input that needs improvement '
      'then get validation warning '
      'and press next button without any changes '
      'must  not stay on character step after pressing next button',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
            characterServiceProvider.overrideWith(
              (ref) => FakeCharacterService(
                validation: characterNeedsImprovementValidation,
              ),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        await fillCharacterInputsWithNeedsImprovementValues(tester);
        await tapNextButtonAndPump(tester);
        expect(find.byType(StoryCreatorCharacterStep), findsOneWidget);
        await tapNextButtonAndPump(tester);
        expect(find.byType(StoryCreatorCharacterStep), findsNothing);
      },
    );

    testWidgets(
      'If user puts character input that needs improvement '
      'validation message must be displayed after pressing next button',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
            characterServiceProvider.overrideWith(
              (ref) => FakeCharacterService(
                validation: characterNeedsImprovementValidation,
              ),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        await fillCharacterInputsWithNeedsImprovementValues(tester);
        await tapNextButtonAndPump(tester);
        expect(
          find.widgetWithText(
            ValidationTextField,
            characterNeedsImprovementValidation.message!,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'If user puts excellent character input '
      'must not  stay on character step after pressing next button',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(
          tester: tester,
          overrides: [
            charactersServiceProvider.overrideWith(
              (ref) => FakeCharactersService.withFakeCharacters(),
            ),
            storyServiceProvider.overrideWith(
              (ref) => FakeStoryService(),
            ),
            characterServiceProvider.overrideWith(
              (ref) => FakeCharacterService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        await fillCharacterInputsWithExcellentValues(tester);
        await tapNextButtonAndPump(tester);
        expect(find.byType(StoryCreatorCharacterStep), findsNothing);
      },
    );
  });
}
