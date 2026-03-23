import 'package:flutter/foundation.dart';

@immutable
class CreateFolderRequest {
  const CreateFolderRequest({
    required this.name,
    this.description,
    this.parentId,
  });

  final String name;
  final String? description;
  final int? parentId;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'name': name,
      'description': description,
      'parentId': parentId,
    };
  }
}

@immutable
class UpdateFolderRequest {
  const UpdateFolderRequest({
    required this.name,
    this.description,
    this.parentId,
  });

  final String name;
  final String? description;
  final int? parentId;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'name': name,
      'description': description,
      'parentId': parentId,
    };
  }
}

@immutable
class RenameFolderRequest {
  const RenameFolderRequest({required this.name});

  final String name;

  Map<String, Object?> toJson() {
    return <String, Object?>{'name': name};
  }
}
