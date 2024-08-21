import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';

part 'story_proposal.g.dart';

@JsonSerializable()
@MapConverter()
class StoryProposals {
  const StoryProposals({
    required this.proposals,
  });

  factory StoryProposals.fromJson(Map<String, dynamic> json) =>
      _$StoryProposalsFromJson(json);

  final List<StoryProposal> proposals;
}

@JsonSerializable()
class StoryProposal with EquatableMixin {
  const StoryProposal({
    required this.plot,
    required this.title,
  });

  factory StoryProposal.fromJson(Map<String, dynamic> json) =>
      _$StoryProposalFromJson(json);

  final String plot;
  final String title;

  Map<String, dynamic> toJson() => _$StoryProposalToJson(this);

  @override
  List<Object?> get props => [
        plot,
        title,
      ];
}
