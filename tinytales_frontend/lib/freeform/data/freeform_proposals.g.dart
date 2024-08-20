// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freeform_proposals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreeformProposals _$FreeformProposalsFromJson(Map<String, dynamic> json) =>
    FreeformProposals(
      proposals: (json['proposals'] as List<dynamic>)
          .map((e) => FreeformProposal.fromJson(
              const MapConverter().fromJson(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$FreeformProposalsToJson(FreeformProposals instance) =>
    <String, dynamic>{
      'proposals': instance.proposals,
    };

FreeformProposal _$FreeformProposalFromJson(Map<String, dynamic> json) =>
    FreeformProposal(
      plot: json['plot'] as String,
      title: json['title'] as String,
      characterName: json['characterName'] as String?,
      characterDescription: json['characterDescription'] as String?,
    );

Map<String, dynamic> _$FreeformProposalToJson(FreeformProposal instance) =>
    <String, dynamic>{
      'plot': instance.plot,
      'title': instance.title,
      'characterName': instance.characterName,
      'characterDescription': instance.characterDescription,
    };
