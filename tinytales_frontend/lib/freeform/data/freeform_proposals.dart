import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';
import 'package:tale_ai_frontend/form/form.dart';

part 'freeform_proposals.g.dart';

@JsonSerializable()
@MapConverter()
class FreeformProposals {
  const FreeformProposals({
    required this.proposals,
  });

  factory FreeformProposals.fromJson(Map<String, dynamic> json) =>
      _$FreeformProposalsFromJson(json);

  final List<FreeformProposal> proposals;
}

@JsonSerializable()
class FreeformProposal extends StoryProposal with EquatableMixin {
  const FreeformProposal({
    required super.plot,
    required super.title,
    this.characterName,
    this.characterDescription,
  });

  factory FreeformProposal.fromJson(Map<String, dynamic> json) =>
      _$FreeformProposalFromJson(json);

  final String? characterName;
  final String? characterDescription;

  @override
  Map<String, dynamic> toJson() => _$FreeformProposalToJson(this);

  @override
  List<Object?> get props => [
        plot,
        title,
        characterName,
        characterDescription,
      ];
}
