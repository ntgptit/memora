import 'package:flutter/material.dart';
import 'package:memora/presentation/features/folder/screens/folder_list_screen.dart';

class FolderDetailScreen extends StatelessWidget {
  const FolderDetailScreen({
    super.key,
    required this.folderId,
  });

  final int folderId;

  @override
  Widget build(BuildContext context) {
    return FolderListScreen(folderId: folderId);
  }
}
