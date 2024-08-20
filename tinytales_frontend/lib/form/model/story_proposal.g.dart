// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_proposal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryProposals _$StoryProposalsFromJson(Map<String, dynamic> json) =>
    StoryProposals(
      proposals: (json['proposals'] as List<dynamic>)
          .map((e) =>
              StoryProposal.fromJson(const MapConverter().fromJson(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$StoryProposalsToJson(StoryProposals instance) =>
    <String, dynamic>{
      'proposals': instance.proposals,
    };

StoryProposal _$StoryProposalFromJson(Map<String, dynamic> json) =>
    StoryProposal(
      plot: json['plot'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$StoryProposalToJson(StoryProposal instance) =>
    <String, dynamic>{
      'plot': instance.plot,
      'title': instance.title,
    };
