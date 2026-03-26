import 'package:json_annotation/json_annotation.dart';

part 'deck_requests.g.dart';

@JsonSerializable(includeIfNull: false)
class CreateDeckRequest {
  const CreateDeckRequest({required this.name, this.description});

  final String name;
  final String? description;

  factory CreateDeckRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateDeckRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateDeckRequestToJson(this);
}

@JsonSerializable(includeIfNull: false)
class UpdateDeckRequest {
  const UpdateDeckRequest({required this.name, this.description});

  final String name;
  final String? description;

  factory UpdateDeckRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateDeckRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateDeckRequestToJson(this);
}
