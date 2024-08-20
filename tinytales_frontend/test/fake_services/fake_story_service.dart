import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/form/model/story_proposal.dart';
import 'package:tale_ai_frontend/story/data/story.dart';
import 'package:tale_ai_frontend/story/data/story_service.dart';

class FakeStoryService extends Fake implements StoryService {
  FakeStoryService({this.storyId, this.stories, this.proposals, this.story});

  final String? storyId;
  final Story? story;
  final List<Story>? stories;
  final List<StoryProposal>? proposals;

  @override
  Future<List<StoryProposal>> createNextAdventureProposals({
    required String taleId,
  }) {
    return Future.value(proposals);
  }

  @override
  Future<List<Story>> getStories({required int pageSize, String? lastStoryId}) {
    return Future.value(stories);
  }

  @override
  Stream<Story?> observeStory(String storyId) async* {
    if (stories != null) {
      for (final story in stories!) {
        if (story.id == storyId) {
          yield story;
          return;
        }
      }
    }
    yield null;
  }
}
