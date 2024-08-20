import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/story/data/data.dart';

final mockLiveValues = [
  for (var i = 0; i < 10; i++)
    LifeValue(
      id: i.toString(),
      description: 'Description $i',
      name: 'Name $i',
      order: i,
    ),
];

class FakeStoryService extends Fake implements StoryService {
  @override
  void deleteStory(String storyId) {}

  @override
  Future<List<LifeValue>> getLifeValues() {
    return Future.value(mockLiveValues);
  }
}
