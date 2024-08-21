import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/story_creator/story_creator.dart';

import 'story_creator_test_utils.dart';

void main() {
  group('StoryCreatorPage story length step', () {
    testWidgets(
      'When StoryCreatorPage is opened length step is displayed',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(tester: tester);
        expect(find.byType(StoryCreatorLengthStep), findsOneWidget);
      },
    );

    testWidgets(
      'Next button is disabled when no length is selected',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(tester: tester);
        expect(findStoryCreatorNextButton(tester).enabled, false);
      },
    );

    testWidgets(
      'Next button is enabled when length is selected',
      (tester) async {
        await pumpTestAppWithStoryCreatorPage(tester: tester);
        await tester.tap(
          find.byType(RadioListTile<SingleSelectionListItem>).first,
        );
        await tester.pumpAndSettle();
        expect(findStoryCreatorNextButton(tester).enabled, true);
      },
    );
  });
}
