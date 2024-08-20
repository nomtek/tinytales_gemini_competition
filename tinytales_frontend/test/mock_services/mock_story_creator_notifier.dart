import 'package:tale_ai_frontend/story_creator/state/story_creator_notifier.dart';
import 'package:tale_ai_frontend/story_creator/state/story_creator_state.dart';

class MockStoryCreatorStateNotifier extends StoryCreatorStateNotifier {
  MockStoryCreatorStateNotifier(this._mockedState);

  final StoryCreatorState _mockedState;
  @override
  StoryCreatorState build() => _mockedState;
}
