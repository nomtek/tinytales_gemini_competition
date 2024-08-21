import 'package:adaptive_test/adaptive_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/auth/auth_state.dart';
import 'package:tale_ai_frontend/history/history_page.dart';
import 'package:tale_ai_frontend/story/story.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

import '../fake_services/fake_story_service.dart';
import '../test_apps/golden_test_app.dart';
import '../test_data/story_test_data.dart';

void main() {
  final stories = [
    aStory(
      id: '1',
      mainCharacterName: 'Alvin',
      title: 'How to help others',
      pictureState: PictureState.pageIllustrationGeneration,
    ),
    aStory(
      pictureState: PictureState.error,
    ),
  ];
  testAdaptiveWidgets('History page', (tester, windowConfig) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
          storyServiceProvider.overrideWith(
            (ref) => FakeStoryService(storyId: '1', stories: stories),
          ),
          progressValueProvider.overrideWith((ref) => 0.66),
        ],
        child: AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            child: NavScaffold(
              selectedIndex: 1,
              child: HistoryPage(),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<HistoryPage>(
      windowConfig,
      waitForImages: false,
      suffix: 'list',
    );
  });
}
