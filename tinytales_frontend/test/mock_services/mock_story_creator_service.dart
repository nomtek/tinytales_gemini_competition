import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/form/model/story_proposal.dart';
import 'package:tale_ai_frontend/story_creator/data/story_creator_service.dart';

class MockStoryCreatorService extends Fake implements StoryCreatorService {
  MockStoryCreatorService({this.proposals});

  final List<StoryProposal>? proposals;

  @override
  Future<List<StoryProposal>> createStoryProposals({
    required String? taleDescription,
    required String characterName,
    required String? characterDescription,
    required List<String> suggestions,
  }) {
    return Future.value(proposals);
  }
}
