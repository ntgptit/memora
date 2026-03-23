import 'package:flutter/foundation.dart';

@immutable
class CreateDeckRequest {
  const CreateDeckRequest({required this.name, this.description});

  final String name;
  final String? description;

  Map<String, Object?> toJson() {
    return <String, Object?>{'name': name, 'description': description};
  }
}

@immutable
class UpdateDeckRequest {
  const UpdateDeckRequest({required this.name, this.description});

  final String name;
  final String? description;

  Map<String, Object?> toJson() {
    return <String, Object?>{'name': name, 'description': description};
  }
}
