package com.memora.app.dto;

public record FolderDto(
    Long id,
    String name,
    String description,
    String colorHex,
    Long parentId,
    Integer depth,
    Long childFolderCount,
    AuditDto audit
) {
}
