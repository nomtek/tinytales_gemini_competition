import 'package:tale_ai_frontend/freeform/data/freeform_proposals.dart';

FreeformProposal aFreeFormProposal({
  String plot = 'plot',
  String title = 'title',
  String characterName = 'characterName',
  String characterDescription = 'characterDescription',
}) =>
    FreeformProposal(
      plot: plot,
      title: title,
      characterName: characterName,
      characterDescription: characterDescription,
    );
