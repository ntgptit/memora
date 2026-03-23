package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.CreateFolderRequest;
import com.memora.app.dto.FolderDto;
import com.memora.app.dto.RenameFolderRequest;
import com.memora.app.dto.UpdateFolderRequest;

public interface FolderService {

    FolderDto createFolder(CreateFolderRequest request);

    FolderDto getFolder(Long folderId);

    List<FolderDto> getFolders(Long parentId, String searchQuery, String sortBy, String sortType, Integer page, Integer size);

    FolderDto renameFolder(Long folderId, RenameFolderRequest request);

    FolderDto updateFolder(Long folderId, UpdateFolderRequest request);

    void deleteFolder(Long folderId);
}
