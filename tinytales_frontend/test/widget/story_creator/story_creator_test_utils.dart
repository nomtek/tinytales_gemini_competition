import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/story_creator/story_creator.dart';

import 'package:tale_ai_frontend/widgets/widgets.dart';

import '../test_app.dart';

final _storyCreatorStepGoBackButtonText = lookupAppLocalizations(
  AppLocalizations.supportedLocales.first,
).storyCreatorActionBack;

Finder storyCreatorStepGoBackButtonFinder() => find.widgetWithText(
      OutlinedButton,
      _storyCreatorStepGoBackButtonText,
    );

final _storyCreatorNextButtonText = lookupAppLocalizations(
  AppLocalizations.supportedLocales.first,
).storyCreatorActionNext;

Finder storyCreatorNextButtonFinder() => find.widgetWithText(
      FilledButton,
      _storyCreatorNextButtonText,
    );

FilledButton findStoryCreatorNextButton(WidgetTester tester) {
  return tester.widget<FilledButton>(
    storyCreatorNextButtonFinder(),
  );
}

final _createStoryButtonText = lookupAppLocalizations(
  AppLocalizations.supportedLocales.first,
).freeformPageActionCreate;

Finder createStoryButtonFinder() => find.widgetWithText(
      FilledButton,
      _createStoryButtonText,
    );

FilledButton findCreateStoryButton(WidgetTester tester) {
  return tester.widget<FilledButton>(
    createStoryButtonFinder(),
  );
}

Finder stepProgressBarFinder(WidgetTester tester) {
  return find.byType(AnimatedStepProgressBar);
}

AnimatedStepProgressBar findStepProgressBar(WidgetTester tester) {
  return tester.widget<AnimatedStepProgressBar>(
    stepProgressBarFinder(tester),
  );
}

Future<void> pumpTestAppWithStoryCreatorPage({
  required WidgetTester tester,
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    TestAppWidget(
      overrides: overrides,
      child: const StoryCreatorPage(),
    ),
  );
}

Future<void> tapBackButtonAndPump(WidgetTester tester) async {
  final buttonToTap = storyCreatorStepGoBackButtonFinder();
  await tester.ensureVisible(buttonToTap);
  await tester.pumpAndSettle();
  await tester.tap(buttonToTap);
  await tester.pumpAndSettle();
}

Future<void> tapNextButtonAndPump(WidgetTester tester) async {
  await tester.tap(storyCreatorNextButtonFinder());
  await tester.pumpAndSettle();
}

Future<void> tapAiAutofillButtonAndPump(WidgetTester tester) async {
  await tester.tap(find.byType(AiAutofillButton));
  await tester.pump();
}

Future<void> goThruLengthStep(WidgetTester tester) async {
  await tester.tap(find.byType(RadioListTile<SingleSelectionListItem>).first);
  await tester.pumpAndSettle();
  await tapNextButtonAndPump(tester);
}

Future<void> goFromCharacterSelectionStepToCustomCharacterStep(
  WidgetTester tester,
) async {
  expect(find.byType(StoryCreatorCharacterSelectionSubstep), findsOneWidget);
  await tester.tap(find.byType(CustomStepTile));
  await tester.pumpAndSettle();
  expect(find.byType(StoryCreatorCharacterCreationSubstep), findsOneWidget);
}

Future<void> fillCharacterInputsWithInappropriateValues(
  WidgetTester tester,
) async {
  await tester.enterText(
    find.byKey(CharacterInput.nameInputKey),
    'inappropriate',
  );
  await tester.enterText(
    find.byKey(CharacterInput.descriptionInputKey),
    'inappropriate',
  );
  await tester.pumpAndSettle();
}

Future<void> fillCharacterInputsWithNeedsImprovementValues(
  WidgetTester tester,
) async {
  await tester.enterText(
    find.byKey(CharacterInput.nameInputKey),
    'needsImprovement',
  );
  await tester.enterText(
    find.byKey(CharacterInput.descriptionInputKey),
    'needsImprovement',
  );
  await tester.pumpAndSettle();
}

Future<void> fillCharacterInputsWithExcellentValues(
  WidgetTester tester,
) async {
  await tester.enterText(
    find.byKey(CharacterInput.nameInputKey),
    'Name',
  );
  await tester.enterText(
    find.byKey(CharacterInput.descriptionInputKey),
    'Description',
  );
  await tester.pumpAndSettle();
}

Future<void> goThruCharacterStepBySelectingCharacter(
  WidgetTester tester,
) async {
  expect(find.byType(StoryCreatorCharacterSelectionSubstep), findsOneWidget);
  await tester.tap(find.byType(SelectableCharacterTile).first);
  await tester.pumpAndSettle();
  await tapNextButtonAndPump(tester);
}

Future<void> goThruCustomCharacterStepByCreatingCharacter(
  WidgetTester tester,
) async {
  expect(find.byType(StoryCreatorCharacterSelectionSubstep), findsOneWidget);
  await tester.tap(find.byType(CustomStepTile));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(CharacterInput.nameInputKey), 'Name');
  await tester.enterText(
    find.byKey(CharacterInput.descriptionInputKey),
    'Description',
  );
  await tester.pumpAndSettle();
  await tapNextButtonAndPump(tester);
}

Future<void> goFromMoralSelectionStepToCustomMoralStep(
  WidgetTester tester,
) async {
  expect(find.byType(StoryCreatorMoralSelectionSubstep), findsOneWidget);
  await tester.tap(find.byType(CustomStepTile));
  await tester.pumpAndSettle();
}

Future<void> goThruMoralStepBySelectingMoral(
  WidgetTester tester,
) async {
  expect(find.byType(StoryCreatorMoralSelectionSubstep), findsOneWidget);
  await tester.tap(find.byType(ActionChip).first);
  await tester.pumpAndSettle();
  await tapNextButtonAndPump(tester);
}

Future<void> goThruMoralStepByCreatingMoral(
  WidgetTester tester,
) async {
  expect(find.byType(StoryCreatorMoralSelectionSubstep), findsOneWidget);
  await tester.tap(find.byType(CustomStepTile));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(ValidationTextField), 'Moral');
  await tester.pumpAndSettle();
  await tapNextButtonAndPump(tester);
}
