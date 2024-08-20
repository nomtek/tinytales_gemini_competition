import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/story/story.dart';
import 'package:tale_ai_frontend/story_creator/story_creator.dart';

import 'package:tale_ai_frontend/widgets/widgets.dart';

import '../../utils/utils.dart';
import '../test_extension.dart';
import 'story_creator_test_utils.dart';

void main() {
  group('StoryCreatorPage moral step', () {
    testWidgets(
      'After completing character step by selecting character, '
      'moral step is displayed in moral selection variant',
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
        await goThruCharacterStepBySelectingCharacter(tester);
        expect(find.byType(StoryCreatorMoralStep), findsOneWidget);
        expect(find.byType(StoryCreatorMoralSelectionSubstep), findsOneWidget);
      },
    );

    testWidgets(
      'After completing character step by creating character, '
      'moral step is displayed in moral selection variant',
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
        await goThruCustomCharacterStepByCreatingCharacter(tester);
        expect(find.byType(StoryCreatorMoralStep), findsOneWidget);
        expect(find.byType(StoryCreatorMoralSelectionSubstep), findsOneWidget);
      },
    );

    testWidgets(
      'After completing character step by selecting character, '
      'and pressing go back button, on moral selection substep, '
      'character selection step is displayed',
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
        await goThruCharacterStepBySelectingCharacter(tester);
        expect(find.byType(StoryCreatorMoralSelectionSubstep), findsOneWidget);
        await tapBackButtonAndPump(tester);
        expect(
          find.byType(StoryCreatorCharacterSelectionSubstep),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'After completing character step by creating character, '
      'and pressing go back button, on moral selection substep, '
      'custom character step is displayed',
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
        await goThruCustomCharacterStepByCreatingCharacter(tester);
        expect(find.byType(StoryCreatorMoralSelectionSubstep), findsOneWidget);
        await tapBackButtonAndPump(tester);
        expect(
          find.byType(StoryCreatorCharacterCreationSubstep),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      'When user did not picked any suggestion on moral suggestion step, '
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
            characterServiceProvider.overrideWith(
              (ref) => FakeCharacterService(),
            ),
          ],
        );

        await goThruLengthStep(tester);
        await goThruCharacterStepBySelectingCharacter(tester);
        expect(find.byType(StoryCreatorMoralSelectionSubstep), findsOneWidget);
        expect(findStoryCreatorNextButton(tester).enabled, false);
      },
    );

    testWidgets(
      'When user picked any suggestion on moral suggestion step, '
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
            characterServiceProvider.overrideWith(
              (ref) => FakeCharacterService(),
            ),
          ],
        );

        await goThruLengthStep(tester);
        await goThruCharacterStepBySelectingCharacter(tester);
        expect(find.byType(StoryCreatorMoralSelectionSubstep), findsOneWidget);
        await tester.tap(find.byType(ActionChip).first);
        await tester.pumpAndSettle();
        expect(findStoryCreatorNextButton(tester).enabled, true);
      },
    );

    testWidgets(
      'When enters the moral selection substep, '
      'for each suggestion, the action chip should be enabled',
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
        await goThruCharacterStepBySelectingCharacter(tester);
        expect(find.byType(StoryCreatorMoralSelectionSubstep), findsOneWidget);
        for (var i = 0; i < mockLiveValues.length; i++) {
          expect(
            tester.widget<ActionChip>(find.byType(ActionChip).at(i)).isEnabled,
            true,
          );
        }
      },
    );

    testWidgets(
      'When user picked three suggestion on moral suggestion step, '
      'the rest of the suggestions should be disabled',
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
        await goThruCharacterStepBySelectingCharacter(tester);
        expect(find.byType(StoryCreatorMoralSelectionSubstep), findsOneWidget);
        await tester.tap(find.byType(ActionChip).first);
        await tester.tap(find.byType(ActionChip).at(1));
        await tester.tap(find.byType(ActionChip).at(2));
        await tester.pumpAndSettle();
        expect(findStoryCreatorNextButton(tester).enabled, true);
        for (var i = 3; i < mockLiveValues.length; i++) {
          expect(
            tester.widget<ActionChip>(find.byType(ActionChip).at(i)).isEnabled,
            false,
          );
        }
      },
    );

    testWidgets(
      'When user taps custom step tile on moral selection substep, '
      'moral creation substep should be displayed',
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
        await goThruCharacterStepBySelectingCharacter(tester);
        await goFromMoralSelectionStepToCustomMoralStep(tester);
        expect(find.byType(StorCreatorMoralCreationSubstep), findsOneWidget);
      },
    );

    testWidgets(
      'When user on moral creation substep did not enter any moral '
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
            characterServiceProvider.overrideWith(
              (ref) => FakeCharacterService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goThruCharacterStepBySelectingCharacter(tester);
        await goFromMoralSelectionStepToCustomMoralStep(tester);
        expect(findStoryCreatorNextButton(tester).enabled, false);
      },
    );

    testWidgets(
      'When user on moral creation substep entered whitespace moral '
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
            characterServiceProvider.overrideWith(
              (ref) => FakeCharacterService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goThruCharacterStepBySelectingCharacter(tester);
        await goFromMoralSelectionStepToCustomMoralStep(tester);
        await tester.enterText(
          find.byType(ValidationTextField),
          '    ',
        );
        await tester.pumpAndSettle();
        expect(findStoryCreatorNextButton(tester).enabled, false);
      },
    );

    testWidgets(
      'When user on moral creation substep entered any moral '
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
            characterServiceProvider.overrideWith(
              (ref) => FakeCharacterService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goThruCharacterStepBySelectingCharacter(tester);
        await goFromMoralSelectionStepToCustomMoralStep(tester);
        await tester.enterText(
          find.byType(ValidationTextField),
          'Moral',
        );
        await tester.pumpAndSettle();
        expect(findStoryCreatorNextButton(tester).enabled, true);
      },
    );
    testWidgets(
      'If user on moral creation substep '
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
            storyCreatorServiceProvider.overrideWith(
              (ref) => FakeStoryCreatorService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goThruCharacterStepBySelectingCharacter(tester);
        await goFromMoralSelectionStepToCustomMoralStep(tester);
        await tapAiAutofillButtonAndPump(tester);
        expect(findStoryCreatorNextButton(tester).enabled, false);
        // Wait for AI autofill result is displayed on the screen
        await tester.pump(const Duration(seconds: 3));
        expect(findStoryCreatorNextButton(tester).enabled, true);
      },
    );

    testWidgets(
      'If user on moral creation substep '
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
            storyCreatorServiceProvider.overrideWith(
              (ref) => FakeStoryCreatorService(),
            ),
          ],
        );

        await goThruLengthStep(tester);
        await goThruCharacterStepBySelectingCharacter(tester);
        await goFromMoralSelectionStepToCustomMoralStep(tester);
        await tapAiAutofillButtonAndPump(tester);
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
      'If user puts excellent moral input '
      'must not  stay on moral step after pressing next button',
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
            storyCreatorServiceProvider.overrideWith(
              (ref) => FakeStoryCreatorService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goThruCharacterStepBySelectingCharacter(tester);
        await goFromMoralSelectionStepToCustomMoralStep(tester);
        await tester.enterText(
          find.byType(ValidationTextField),
          'Moral',
        );
        await tester.pumpAndSettle();
        await tapNextButtonAndPump(tester);
        expect(find.byType(StoryCreatorMoralStep), findsNothing);
      },
    );

    testWidgets(
      'If user puts moral input that needs improvements '
      'must stay on moral creation substep after pressing next button',
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
            storyCreatorServiceProvider.overrideWith(
              (ref) => FakeStoryCreatorService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goThruCharacterStepBySelectingCharacter(tester);
        await goFromMoralSelectionStepToCustomMoralStep(tester);
        await tester.enterText(
          find.byType(ValidationTextField),
          'needsImprovement',
        );
        await tester.pumpAndSettle();
        await tapNextButtonAndPump(tester);
        expect(find.byType(StorCreatorMoralCreationSubstep), findsOneWidget);
      },
    );

    testWidgets(
      'If user puts moral input that needs improvement '
      'then get validation warning '
      'and press next button without any changes '
      'must  not stay on moral step after pressing next button',
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
            storyCreatorServiceProvider.overrideWith(
              (ref) => FakeStoryCreatorService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goThruCharacterStepBySelectingCharacter(tester);
        await goFromMoralSelectionStepToCustomMoralStep(tester);
        await tester.enterText(
          find.byType(ValidationTextField),
          'needsImprovement',
        );
        await tester.pumpAndSettle();
        await tapNextButtonAndPump(tester);
        expect(find.byType(StorCreatorMoralCreationSubstep), findsOneWidget);
        await tapNextButtonAndPump(tester);
        expect(find.byType(StoryCreatorMoralStep), findsNothing);
      },
    );

    testWidgets(
      'If user puts moral input that needs improvements '
      'validation message should be displayed after pressing next button',
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
            storyCreatorServiceProvider.overrideWith(
              (ref) => FakeStoryCreatorService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goThruCharacterStepBySelectingCharacter(tester);
        await goFromMoralSelectionStepToCustomMoralStep(tester);
        await tester.enterText(
          find.byType(ValidationTextField),
          'needsImprovement',
        );
        await tester.pumpAndSettle();
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
      'If user puts inappropriate moral input '
      'must stay on moral creation substep after pressing next button',
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
            storyCreatorServiceProvider.overrideWith(
              (ref) => FakeStoryCreatorService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goThruCharacterStepBySelectingCharacter(tester);
        await goFromMoralSelectionStepToCustomMoralStep(tester);
        await tester.enterText(
          find.byType(ValidationTextField),
          'inappropriate',
        );
        await tester.pumpAndSettle();
        await tapNextButtonAndPump(tester);
        expect(find.byType(StorCreatorMoralCreationSubstep), findsOneWidget);
      },
    );

    testWidgets(
      'If user puts inappropriate moral input '
      'then get validation error '
      'and press next button without any changes '
      'must stay on moral step after pressing next button',
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
            storyCreatorServiceProvider.overrideWith(
              (ref) => FakeStoryCreatorService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goThruCharacterStepBySelectingCharacter(tester);
        await goFromMoralSelectionStepToCustomMoralStep(tester);
        await tester.enterText(
          find.byType(ValidationTextField),
          'inappropriate',
        );
        await tester.pumpAndSettle();
        await tapNextButtonAndPump(tester);
        expect(find.byType(StorCreatorMoralCreationSubstep), findsOneWidget);
        await tapNextButtonAndPump(tester);
        expect(find.byType(StorCreatorMoralCreationSubstep), findsOneWidget);
      },
    );

    testWidgets(
      'If user puts inappropriate moral input '
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
              (ref) => FakeCharacterService(),
            ),
            storyCreatorServiceProvider.overrideWith(
              (ref) => FakeStoryCreatorService(),
            ),
          ],
        );
        await goThruLengthStep(tester);
        await goThruCharacterStepBySelectingCharacter(tester);
        await goFromMoralSelectionStepToCustomMoralStep(tester);
        await tester.enterText(
          find.byType(ValidationTextField),
          'inappropriate',
        );
        await tester.pumpAndSettle();
        await tapNextButtonAndPump(tester);
        expect(
          find.widgetWithText(
            ValidationTextField,
            moralInappropriateValidation.message!,
          ),
          findsOneWidget,
        );
      },
    );
  });
}
