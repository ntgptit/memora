import 'package:json_annotation/json_annotation.dart';

part 'api_audit_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class ApiAuditDto {
  const ApiAuditDto({
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.version,
  });

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int? version;

  factory ApiAuditDto.fromJson(Map<String, dynamic> json) =>
      _$ApiAuditDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ApiAuditDtoToJson(this);
}
