import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/freeform/data/freeform_proposals.dart';

part 'freeform_service.g.dart';

@riverpod
FreeformService freeformService(FreeformServiceRef ref) {
  final functions = ref.watch(firebaseFunctionsProvider);
  return FreeformService(functions);
}

class FreeformService {
  FreeformService(this._functions);

  final FirebaseFunctions _functions;

  Future<Validation> validateContent({
    required String content,
  }) {
    final result = _functions.callJson(
      'validateFreeForm',
      params: {
        _textParam: content,
      },
    );

    final validation = result.then((result) {
      return Validation.fromJson(result.data);
    });

    return validation;
  }

  Future<List<FreeformProposal>> createStoryProposals({
    required String content,
  }) async {
    final result = await _functions.callJson(
      'freeForm',
      params: {
        _textParam: content,
      },
    );

    final proposals = FreeformProposals.fromJson(result.data).proposals;

    return proposals;
  }

  Future<String> createStory({
    required List<FreeformProposal> proposals,
    required int chosenProposalIndex,
  }) async {
    final result = await _functions.callJson(
      'createTale',
      params: {
        'proposals': proposals.map((e) => e.toJson()).toList(),
        'chosenProposalIndex': chosenProposalIndex,
        'characterName': proposals[chosenProposalIndex].characterName,
        'characterDescription':
            proposals[chosenProposalIndex].characterDescription,
      },
    );
    return result.data['taleId'] as String;
  }
}

const _textParam = 'text';
