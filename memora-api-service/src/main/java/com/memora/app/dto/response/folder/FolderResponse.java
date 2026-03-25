package com.memora.app.dto.response.folder;

import com.memora.app.dto.common.AuditDto;

public record FolderResponse(
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




