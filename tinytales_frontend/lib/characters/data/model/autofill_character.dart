import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class AutofillCharacter with EquatableMixin {
  const AutofillCharacter({
    required this.name,
    required this.description,
  });
  final String name;
  final String description;

  @override
  List<Object?> get props => [name, description];

  @override
  bool? get stringify => true;
}
