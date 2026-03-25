package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.request.folder.CreateFolderRequest;
import com.memora.app.dto.response.folder.FolderResponse;
import com.memora.app.dto.request.folder.RenameFolderRequest;
import com.memora.app.dto.request.folder.UpdateFolderRequest;

public interface FolderService {

    FolderResponse createFolder(CreateFolderRequest request);

    FolderResponse getFolder(Long folderId);

    List<FolderResponse> getFolders(Long parentId, String searchQuery, String sortBy, String sortType, Integer page, Integer size);

    FolderResponse renameFolder(Long folderId, RenameFolderRequest request);

    FolderResponse updateFolder(Long folderId, UpdateFolderRequest request);

    void deleteFolder(Long folderId);
}



