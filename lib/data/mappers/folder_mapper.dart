import 'package:memora/data/models/folder_model.dart';
import 'package:memora/domain/entities/folder.dart';

abstract final class FolderMapper {
  static Folder toEntity(FolderModel model) {
    return Folder(
      id: model.id,
      name: model.name,
      description: model.description,
      colorHex: model.colorHex,
      parentId: model.parentId,
      depth: model.depth,
      childFolderCount: model.childFolderCount,
    );
  }
}
