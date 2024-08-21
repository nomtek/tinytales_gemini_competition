import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/auth/auth_state.dart';
import 'package:tale_ai_frontend/characters/data/characters_service.dart';
import 'package:tale_ai_frontend/form/proposals_view.dart';
import 'package:tale_ai_frontend/story/data/life_value.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/steps.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';
import 'package:tale_ai_frontend/story_creator/story_creator_page.dart';

import '../mock_services/mock_characters_service.dart';
import '../mock_services/mock_story_creator_notifier.dart';
import '../test_apps/golden_test_app.dart';
import '../test_data/character_test_data.dart';
import '../test_data/story_proposal_test_data.dart';

void main() {
  testAdaptiveWidgets('Story creator form', (tester, windowConfig) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
        ],
        child: AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            themeMode: ThemeMode.dark,
            child: StoryCreatorPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<StoryCreatorPage>(
      windowConfig,
      suffix: 'length',
      waitForImages: false,
    );
  });

  testAdaptiveWidgets('Story creator select character step', (
    tester,
    windowConfig,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
          currentStepIndexProvider.overrideWithValue(1),
          charactersServiceProvider.overrideWith(
            (ref) => MockCharactersService(
              characters: [
                aCharacter(name: 'Gawcio'),
                aCharacter(name: 'Glipsiu'),
                aCharacter(name: 'Kinkpin'),
                aCharacter(name: 'Grulak'),
                aCharacter(name: 'Jesiok'),
              ],
            ),
          ),
        ],
        child: AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            themeMode: ThemeMode.dark,
            child: StoryCreatorPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<StoryCreatorPage>(
      windowConfig,
      suffix: 'characters',
      waitForImages: false,
    );
  });

  testAdaptiveWidgets('Story creator character creation step', (
    tester,
    windowConfig,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
          currentStepIndexProvider.overrideWithValue(1),
          characterStepTypeProvider.overrideWithValue(StepType.creation),
        ],
        child: AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            themeMode: ThemeMode.dark,
            child: StoryCreatorPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<StoryCreatorPage>(
      windowConfig,
      suffix: 'character_creation',
      waitForImages: false,
    );
  });

  testAdaptiveWidgets('Story creator select moral step', (
    tester,
    windowConfig,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
          currentStepIndexProvider.overrideWithValue(2),
          lifeValuesProvider.overrideWith(
            (ref) => [
              LifeValue(
                id: '1',
                name: 'Be brave',
                description: 'Be brave description',
                order: 1,
              ),
              LifeValue(
                id: '2',
                name: 'Be kind',
                description: 'Be kind description',
                order: 2,
              ),
              LifeValue(
                id: '3',
                name: 'Be honest',
                description: 'Be honest description',
                order: 3,
              ),
              LifeValue(
                id: '4',
                name: 'Be loyal',
                description: 'Be loyal description',
                order: 4,
              ),
              LifeValue(
                id: '5',
                name: 'Be respectful',
                description: 'Be respectful description',
                order: 5,
              ),
            ],
          ),
        ],
        child: AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            themeMode: ThemeMode.dark,
            child: StoryCreatorPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<StoryCreatorPage>(
      windowConfig,
      suffix: 'moral',
      waitForImages: false,
    );
  });

  testAdaptiveWidgets('Story creator custom moral step', (
    tester,
    windowConfig,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
          currentStepIndexProvider.overrideWithValue(2),
          storyMoralStepTypeProvider.overrideWithValue(StepType.creation),
        ],
        child: AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            themeMode: ThemeMode.dark,
            child: StoryCreatorPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<StoryCreatorPage>(
      windowConfig,
      suffix: 'custom_moral',
      waitForImages: false,
    );
  });

  testAdaptiveWidgets('Story creator proposal step', (
    tester,
    windowConfig,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
          storyCreatorStateNotifierProvider.overrideWith(
            () => MockStoryCreatorStateNotifier(
              StoryCreatorState(
                currentStep: StoryCreatorStep.proposals,
                proposalsStep: ProposalsViewState(
                  storyProposals: [
                    aStoryProposal(plot: 'Plot 1', title: 'Title 1'),
                    aStoryProposal(plot: 'Plot 2', title: 'Title 2'),
                    aStoryProposal(plot: 'Plot 3', title: 'Title 3'),
                  ],
                ),
              ),
            ),
          ),
        ],
        child: AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            themeMode: ThemeMode.dark,
            child: StoryCreatorPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<StoryCreatorPage>(
      windowConfig,
      suffix: 'proposals',
      waitForImages: false,
    );
  });
}
