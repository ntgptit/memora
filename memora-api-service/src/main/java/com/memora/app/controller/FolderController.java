package com.memora.app.controller;

import java.util.List;

import com.memora.app.dto.CreateFolderRequest;
import com.memora.app.dto.FolderDto;
import com.memora.app.dto.UpdateFolderRequest;
import com.memora.app.service.FolderService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * REST endpoints for folder management.
 */
@Tag(name = "Folders", description = "CRUD APIs for Memora folders")
@RestController
@RequestMapping("/api/v1/folders")
@RequiredArgsConstructor
public class FolderController {

    private final FolderService folderService;

    /**
     * Create a folder.
     *
     * @param request folder payload
     * @return created folder
     */
    @Operation(summary = "Create folder")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Folder created"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "User or parent folder not found"),
        @ApiResponse(responseCode = "409", description = "Folder name already exists or hierarchy is invalid")
    })
    @PostMapping
    public ResponseEntity<FolderDto> createFolder(@Valid @RequestBody final CreateFolderRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(folderService.createFolder(request));
    }

    /**
     * Get a folder by id.
     *
     * @param folderId folder identifier
     * @return folder details
     */
    @Operation(summary = "Get folder by id")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Folder found"),
        @ApiResponse(responseCode = "404", description = "Folder not found")
    })
    @GetMapping("/{folderId}")
    public ResponseEntity<FolderDto> getFolder(@PathVariable final Long folderId) {
        return ResponseEntity.ok(folderService.getFolder(folderId));
    }

    /**
     * List folders.
     *
     * @param userId optional owner filter
     * @param parentId optional parent filter
     * @return matching folders
     */
    @Operation(summary = "List folders")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Folders loaded")
    })
    @GetMapping
    public ResponseEntity<List<FolderDto>> getFolders(
        @RequestParam(required = false) final Long userId,
        @RequestParam(required = false) final Long parentId
    ) {
        return ResponseEntity.ok(folderService.getFolders(userId, parentId));
    }

    /**
     * Update a folder.
     *
     * @param folderId folder identifier
     * @param request updated folder payload
     * @return updated folder
     */
    @Operation(summary = "Update folder")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Folder updated"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Folder not found"),
        @ApiResponse(responseCode = "409", description = "Folder hierarchy or folder name is invalid")
    })
    @PutMapping("/{folderId}")
    public ResponseEntity<FolderDto> updateFolder(
        @PathVariable final Long folderId,
        @Valid @RequestBody final UpdateFolderRequest request
    ) {
        return ResponseEntity.ok(folderService.updateFolder(folderId, request));
    }

    /**
     * Soft delete a folder.
     *
     * @param folderId folder identifier
     * @return empty response
     */
    @Operation(summary = "Delete folder")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Folder deleted"),
        @ApiResponse(responseCode = "404", description = "Folder not found"),
        @ApiResponse(responseCode = "409", description = "Folder still has child folders or decks")
    })
    @DeleteMapping("/{folderId}")
    public ResponseEntity<Void> deleteFolder(@PathVariable final Long folderId) {
        folderService.deleteFolder(folderId);
        return ResponseEntity.noContent().build();
    }
}
