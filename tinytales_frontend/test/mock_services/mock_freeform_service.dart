import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/form/model/validation.dart';
import 'package:tale_ai_frontend/freeform/data/freeform_proposals.dart';
import 'package:tale_ai_frontend/freeform/data/freeform_service.dart';

class MockFreeformService extends Fake implements FreeformService {
  MockFreeformService({this.proposals, this.story, this.validation});

  final List<FreeformProposal>? proposals;
  final String? story;
  final Validation? validation;

  @override
  Future<String> createStory({
    required List<FreeformProposal> proposals,
    required int chosenProposalIndex,
  }) {
    return Future.value(story);
  }

  @override
  Future<List<FreeformProposal>> createStoryProposals({
    required String content,
  }) {
    return Future.value(proposals);
  }

  @override
  Future<Validation> validateContent({required String content}) {
    return Future.value(
      validation ??
          const Validation(
            valid: true,
            validationStatus: ValidationStatus.excellent,
            suggestedVersion: SuggestedVersion(),
          ),
    );
  }
}
