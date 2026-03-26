import 'package:json_annotation/json_annotation.dart';

part 'audit_model.g.dart';

@JsonSerializable(includeIfNull: false)
class AuditModel {
  const AuditModel({
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.version,
  });

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int? version;

  factory AuditModel.fromJson(Map<String, dynamic> json) =>
      _$AuditModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuditModelToJson(this);
}
