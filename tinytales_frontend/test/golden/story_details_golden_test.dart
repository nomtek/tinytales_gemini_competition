import 'package:adaptive_test/adaptive_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/auth/auth_state.dart';
import 'package:tale_ai_frontend/persistance/shared_prefs_provider.dart';
import 'package:tale_ai_frontend/story/data/story.dart';
import 'package:tale_ai_frontend/story/data/story_service.dart';
import 'package:tale_ai_frontend/story/story_page.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

import '../fake_services/fake_shared_prefs.dart';
import '../fake_services/fake_story_service.dart';
import '../test_apps/golden_test_app.dart';
import '../test_data/story_test_data.dart';

void main() {
  final story1 = aStory(
    id: '1',
    mainCharacterName: 'Alvin',
    title: 'How to help others',
    pictureState: PictureState.pageIllustrationGeneration,
  );

  final story2 = aStory(
    id: '2',
    mainCharacterName: 'Alvin',
    title: 'How to help others',
    pictureState: PictureState.error,
  );
  final stories = [
    story1,
    story2,
  ];
  testAdaptiveWidgets('Story details page with image placeholder',
      (tester, windowConfig) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
          storyServiceProvider.overrideWith(
            (ref) => FakeStoryService(
              storyId: '2',
              story: story2,
              stories: stories,
            ),
          ),
          sharedPreferencesProvider.overrideWith(
            (ref) => FakeSharedPreferences(),
          ),
          progressValueProvider.overrideWith((ref) => 0.0),
        ],
        child: AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            child: StoryPage(
              storyId: '2',
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<StoryPage>(
      windowConfig,
      suffix: 'picture_placeholder',
      waitForImages: false,
    );
  });

  testAdaptiveWidgets('Story details page with image loading state',
      (tester, windowConfig) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
          storyServiceProvider.overrideWith(
            (ref) => FakeStoryService(
              storyId: '1',
              story: story1,
              stories: stories,
            ),
          ),
          sharedPreferencesProvider.overrideWith(
            (ref) => FakeSharedPreferences(),
          ),
          progressValueProvider.overrideWith((ref) => 0.66),
        ],
        child: AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            child: StoryPage(
              storyId: '1',
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<StoryPage>(
      windowConfig,
      suffix: 'loading_picture',
      waitForImages: false,
    );
  });
}
