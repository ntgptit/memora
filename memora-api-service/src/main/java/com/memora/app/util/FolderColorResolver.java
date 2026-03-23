package com.memora.app.util;

import lombok.experimental.UtilityClass;

@UtilityClass
public class FolderColorResolver {

    private static final String[] COLOR_PALETTE = {
        "#4F46E5",
        "#0EA5E9",
        "#10B981",
        "#F59E0B",
        "#EF4444",
        "#8B5CF6",
        "#14B8A6",
        "#EC4899",
        "#84CC16",
        "#F97316",
        "#6366F1",
        "#06B6D4"
    };

    public static String resolve(final Long folderId) {
        if (folderId == null || folderId <= 0L) {
            return COLOR_PALETTE[0];
        }
        final int index = Math.floorMod(folderId, COLOR_PALETTE.length);
        return COLOR_PALETTE[index];
    }
}
