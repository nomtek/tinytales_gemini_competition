import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/story/story.dart';
import 'package:tale_ai_frontend/story_creator/story_creator.dart';

import '../../utils/utils.dart';
import 'story_creator_test_utils.dart';

void main() {
  testWidgets(
    'StoryCreatorPage renders correctly',
    (WidgetTester tester) async {
      await pumpTestAppWithStoryCreatorPage(tester: tester);
      expect(find.byType(StoryCreatorPage), findsOneWidget);
    },
  );

  testWidgets(
    'When tap on close button, display confirmation dialog',
    (tester) async {
      await pumpTestAppWithStoryCreatorPage(tester: tester);
      await tester.tap(find.byType(CloseButton));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    },
  );

  group('StorCreatorPage step progress bar', () {
    testWidgets(
      'When Story page is on story length step, step progress bar is in 1/4',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(tester: tester);
        expect(find.byType(StoryCreatorLengthStep), findsOneWidget);
        expect(stepProgressBarFinder(tester), findsOneWidget);
        final stepProgressBar = findStepProgressBar(tester);
        expect(
          stepProgressBar.stepsCount,
          StoryCreatorStep.values.length,
        );
        expect(stepProgressBar.currentStepIndex, 0);
        expect(stepProgressBar.previousStepIndex, 0);
      },
    );

    testWidgets(
      'When Story page is on character creation substep, step progress bar is in 2/4',
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
        expect(stepProgressBarFinder(tester), findsOneWidget);
        final stepProgressBar = findStepProgressBar(tester);
        expect(
          stepProgressBar.stepsCount,
          StoryCreatorStep.values.length,
        );
        expect(stepProgressBar.currentStepIndex, 1);
        expect(stepProgressBar.previousStepIndex, 0);
      },
    );

    testWidgets(
      'When Story page is on character selection substep, step progress bar is in 2/4',
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
        expect(stepProgressBarFinder(tester), findsOneWidget);
        final stepProgressBar = findStepProgressBar(tester);
        expect(
          stepProgressBar.stepsCount,
          StoryCreatorStep.values.length,
        );
        expect(stepProgressBar.currentStepIndex, 1);
        expect(stepProgressBar.previousStepIndex, 0);
      },
    );

    testWidgets(
      'When Story page is on character selection step '
      'then enters character creation substep, '
      'step progress bar is in 2/4',
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
        await goFromCharacterSelectionStepToCustomCharacterStep(tester);
        expect(
          find.byType(StoryCreatorCharacterCreationSubstep),
          findsOneWidget,
        );
        expect(stepProgressBarFinder(tester), findsOneWidget);
        final stepProgressBar = findStepProgressBar(tester);
        expect(
          stepProgressBar.stepsCount,
          StoryCreatorStep.values.length,
        );
        expect(stepProgressBar.currentStepIndex, 1);
        expect(stepProgressBar.previousStepIndex, 0);
      },
    );

    testWidgets(
      'When Story page is on moral selection substep, step progress bar is in 3/4',
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
        expect(stepProgressBarFinder(tester), findsOneWidget);
        final stepProgressBar = findStepProgressBar(tester);
        expect(
          stepProgressBar.stepsCount,
          StoryCreatorStep.values.length,
        );
        expect(stepProgressBar.currentStepIndex, 2);
        expect(stepProgressBar.previousStepIndex, 1);
      },
    );

    testWidgets(
      'When Story page is on moral selection substep '
      'then enters moral creation substep, '
      'step progress bar is in 3/4',
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
        expect(stepProgressBarFinder(tester), findsOneWidget);
        final stepProgressBar = findStepProgressBar(tester);
        expect(
          stepProgressBar.stepsCount,
          StoryCreatorStep.values.length,
        );
        expect(stepProgressBar.currentStepIndex, 2);
        expect(stepProgressBar.previousStepIndex, 1);
      },
    );

    testWidgets(
      'When Story page is on proposals step, step progress bar is in 4/4',
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
        await goThruMoralStepBySelectingMoral(tester);
        expect(find.byType(StoryCreatorProposalsStep), findsOneWidget);
        expect(stepProgressBarFinder(tester), findsOneWidget);
        final stepProgressBar = findStepProgressBar(tester);
        expect(
          stepProgressBar.stepsCount,
          StoryCreatorStep.values.length,
        );
        expect(stepProgressBar.currentStepIndex, 3);
        expect(stepProgressBar.previousStepIndex, 2);
      },
    );

    testWidgets(
      'When Story page is on character selection step, step progress is set to 2/4 '
      'then tap go back '
      'story page should be on story length step and step progress bar is set to 1/4 on  ',
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
        expect(
          find.byType(StoryCreatorCharacterSelectionSubstep),
          findsOneWidget,
        );
        expect(stepProgressBarFinder(tester), findsOneWidget);
        final stepProgressBar = findStepProgressBar(tester);
        expect(
          stepProgressBar.stepsCount,
          StoryCreatorStep.values.length,
        );
        expect(stepProgressBar.currentStepIndex, 1);
        expect(stepProgressBar.previousStepIndex, 0);

        await tapBackButtonAndPump(tester);
        expect(find.byType(StoryCreatorLengthStep), findsOneWidget);
        expect(stepProgressBarFinder(tester), findsOneWidget);
        final stepProgressBarAfterBack = findStepProgressBar(tester);
        expect(
          stepProgressBarAfterBack.stepsCount,
          StoryCreatorStep.values.length,
        );
        expect(stepProgressBarAfterBack.currentStepIndex, 0);
        expect(stepProgressBarAfterBack.previousStepIndex, 1);
      },
    );

    testWidgets(
      'When Story page is on character creation substep displayed after '
      'character selection step, step progress is set to 2/4 '
      'then tap go back '
      'story page should be on character selection step and step progress bar is set to 2/4 on  ',
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
        expect(
          find.byType(StoryCreatorCharacterCreationSubstep),
          findsOneWidget,
        );
        expect(stepProgressBarFinder(tester), findsOneWidget);
        final stepProgressBar = findStepProgressBar(tester);
        expect(
          stepProgressBar.stepsCount,
          StoryCreatorStep.values.length,
        );
        expect(stepProgressBar.currentStepIndex, 1);
        expect(stepProgressBar.previousStepIndex, 0);

        await tapBackButtonAndPump(tester);
        expect(
          find.byType(StoryCreatorCharacterSelectionSubstep),
          findsOneWidget,
        );
        expect(stepProgressBarFinder(tester), findsOneWidget);
        final stepProgressBarAfterBack = findStepProgressBar(tester);
        expect(
          stepProgressBarAfterBack.stepsCount,
          StoryCreatorStep.values.length,
        );
        expect(stepProgressBarAfterBack.currentStepIndex, 1);
        expect(stepProgressBarAfterBack.previousStepIndex, 0);
      },
    );
  });
}
