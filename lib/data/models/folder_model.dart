import 'package:json_annotation/json_annotation.dart';
import 'package:memora/data/models/audit_model.dart';

part 'folder_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FolderModel {
  const FolderModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.depth,
    required this.childFolderCount,
    required this.audit,
    this.description = '',
    this.colorHex = '#4F46E5',
  });

  final int id;
  final String name;
  @JsonKey(defaultValue: '')
  final String description;
  @JsonKey(defaultValue: '#4F46E5')
  final String colorHex;
  final int? parentId;
  final int depth;
  final int childFolderCount;
  final AuditModel? audit;

  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);

  Map<String, dynamic> toJson() => _$FolderModelToJson(this);
}
