import 'package:flutter/foundation.dart';

@immutable
class Folder {
  const Folder({
    required this.id,
    required this.name,
    required this.description,
    required this.colorHex,
    required this.parentId,
    required this.depth,
    required this.childFolderCount,
  });

  final int id;
  final String name;
  final String description;
  final String colorHex;
  final int? parentId;
  final int depth;
  final int childFolderCount;

  bool get isLeaf => childFolderCount == 0;
  bool get hasDescription => description.trim().isNotEmpty;
}

enum FolderSortField {
  name('NAME'),
  createdAt('CREATED_AT'),
  updatedAt('UPDATED_AT');

  const FolderSortField(this.apiValue);

  final String apiValue;
}
