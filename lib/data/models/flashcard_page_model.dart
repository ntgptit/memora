import 'package:json_annotation/json_annotation.dart';
import 'package:memora/data/models/flashcard_model.dart';

part 'flashcard_page_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FlashcardPageModel {
  const FlashcardPageModel({
    required this.items,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<FlashcardModel> items;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  factory FlashcardPageModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$FlashcardPageModelToJson(this);
}
