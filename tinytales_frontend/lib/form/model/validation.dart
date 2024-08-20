import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';

part 'validation.g.dart';

@immutable
@JsonSerializable()
@MapConverter()
class Validation with EquatableMixin {
  const Validation({
    required this.valid,
    required this.validationStatus,
    required this.suggestedVersion,
    this.id,
    this.message,
  });

  factory Validation.fromJson(Map<String, dynamic> json) {
    final withoutId = _$ValidationFromJson(json);
    return Validation(
      valid: withoutId.valid,
      validationStatus: withoutId.validationStatus,
      suggestedVersion: withoutId.suggestedVersion,
      message: withoutId.message,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  // This ID exist to distinguish between different validation results
  // it is helpful when we want to show a11y announcement
  // used in story_creator_form.dart, character_page.dart
  @JsonKey(includeFromJson: false)
  final String? id;
  final bool valid;
  final String? message;
  final ValidationStatus validationStatus;
  final SuggestedVersion suggestedVersion;

  @override
  List<Object?> get props => [
        id,
        valid,
        message,
        validationStatus,
        suggestedVersion,
      ];

  @override
  bool? get stringify => true;
}

enum ValidationStatus {
  @JsonValue('Inappropriate')
  inappropriate,
  @JsonValue('Needs Improvement')
  needsImprovement,
  @JsonValue('Excellent')
  excellent,
}

@JsonSerializable()
class SuggestedVersion with EquatableMixin {
  const SuggestedVersion({
    this.name,
    this.description,
    this.content,
  });

  factory SuggestedVersion.fromJson(Map<String, dynamic> json) =>
      _$SuggestedVersionFromJson(json);

  final String? name;
  final String? description;
  final String? content;

  @override
  List<Object?> get props => [name, description, content];
}

extension ValidationX on Validation {
  bool get isValid => validationStatus != ValidationStatus.inappropriate;
  bool get showShowAutofixForTwoFields =>
      validationStatus == ValidationStatus.needsImprovement &&
      (suggestedVersion.name != null || suggestedVersion.description != null);
  bool get showAutofixForOneField =>
      validationStatus == ValidationStatus.needsImprovement &&
      suggestedVersion.content != null;
}
