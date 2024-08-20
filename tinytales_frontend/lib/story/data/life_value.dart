import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';

part 'life_value.g.dart';

@JsonSerializable()
class LifeValue with EquatableMixin {
  LifeValue({
    required this.id,
    required this.description,
    required this.name,
    required this.order,
  });

  factory LifeValue.fromJson(Map<String, dynamic> json) =>
      _$LifeValueFromJson(json);

  /// This is a document id in Firestore.
  ///
  /// It's not a part of the data model.
  ///
  /// It's used to identify the document in Firestore.
  ///
  /// It's not included in the `toJson` method.
  ///
  /// Must be available in the `fromJson` method
  /// - use [DocumentSnapshotX.dataWithDocId] extension.
  @JsonKey(name: firestoreDocIdKey, includeToJson: false)
  final String id;
  final String description;
  final String name;
  final int order;

  @override
  List<Object?> get props => [
        id,
        description,
        name,
        order,
      ];
}
