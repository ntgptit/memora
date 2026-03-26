import 'package:json_annotation/json_annotation.dart';

part 'folder_requests.g.dart';

@JsonSerializable(includeIfNull: false)
class CreateFolderRequest {
  const CreateFolderRequest({
    required this.name,
    this.description,
    this.parentId,
  });

  final String name;
  final String? description;
  final int? parentId;

  factory CreateFolderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFolderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFolderRequestToJson(this);
}

@JsonSerializable(includeIfNull: false)
class UpdateFolderRequest {
  const UpdateFolderRequest({
    required this.name,
    this.description,
    this.parentId,
  });

  final String name;
  final String? description;
  final int? parentId;

  factory UpdateFolderRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateFolderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFolderRequestToJson(this);
}

@JsonSerializable(includeIfNull: false)
class RenameFolderRequest {
  const RenameFolderRequest({required this.name});

  final String name;

  factory RenameFolderRequest.fromJson(Map<String, dynamic> json) =>
      _$RenameFolderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RenameFolderRequestToJson(this);
}
