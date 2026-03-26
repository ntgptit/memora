import 'package:json_annotation/json_annotation.dart';
import 'package:memora/data/models/api_audit_dto.dart';

part 'folder_dto.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class FolderDto {
  const FolderDto({
    required this.id,
    required this.name,
    required this.depth,
    required this.childFolderCount,
    required this.audit,
    this.parentId,
    this.description,
    this.colorHex,
  });

  final int id;
  final int? parentId;
  final String name;
  final String? description;
  final String? colorHex;
  final int depth;
  final int childFolderCount;
  final ApiAuditDto audit;

  factory FolderDto.fromJson(Map<String, dynamic> json) =>
      _$FolderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FolderDtoToJson(this);
}
