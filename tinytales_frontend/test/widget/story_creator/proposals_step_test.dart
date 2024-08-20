import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/story/story.dart';
import 'package:tale_ai_frontend/story_creator/story_creator.dart';

import '../../utils/utils.dart';
import 'story_creator_test_utils.dart';

void main() {
  group('StoryCreatorPage proposals step', () {
    testWidgets(
      'After completing moral step by selecting moral, '
      'proposal step is displayed',
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
      },
    );
    testWidgets(
      'After completing moral step by creating moral, '
      'proposal step is displayed',
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
        await goThruMoralStepByCreatingMoral(tester);
        expect(find.byType(StoryCreatorProposalsStep), findsOneWidget);
      },
    );
    testWidgets(
      'After completing moral step by selecting moral, '
      'and pressing go back button, on proposals step, '
      'moral selection step is displayed',
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
        await tapBackButtonAndPump(tester);
        expect(find.byType(StoryCreatorMoralSelectionSubstep), findsOneWidget);
      },
    );
    testWidgets(
      'After completing moral step by creating moral, '
      'and pressing go back button, on proposals step, '
      'custom moral step is displayed',
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
        await goThruMoralStepByCreatingMoral(tester);
        expect(find.byType(StoryCreatorProposalsStep), findsOneWidget);
        await tapBackButtonAndPump(tester);
        expect(find.byType(StorCreatorMoralCreationSubstep), findsOneWidget);
      },
    );
    testWidgets(
      'When user did not picked any proposal on proposals step, '
      'create story button should be disabled',
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
        expect(findCreateStoryButton(tester).enabled, false);
      },
    );

    testWidgets(
      'When user picked any proposal on proposals step, '
      'create story button should be enabled',
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
        await goThruMoralStepBySelectingMoral(tester);
        await tester
            .tap(find.byType(RadioListTile<SingleSelectionListItem>).first);
        await tester.pumpAndSettle();
        expect(findCreateStoryButton(tester).enabled, true);
      },
    );
  });
}
