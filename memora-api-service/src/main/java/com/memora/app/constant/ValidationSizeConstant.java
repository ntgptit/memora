package com.memora.app.constant;

import lombok.experimental.UtilityClass;

@UtilityClass
public class ValidationSizeConstant {

    public static final int USERNAME_MAX_LENGTH = 40;
    public static final int EMAIL_MAX_LENGTH = 120;
    public static final int PASSWORD_MIN_LENGTH = 8;
    public static final int PASSWORD_MAX_LENGTH = 240;
    public static final int FOLDER_NAME_MAX_LENGTH = 120;
    public static final int DECK_NAME_MAX_LENGTH = 120;
    public static final int REVIEW_PROFILE_NAME_MAX_LENGTH = 120;
    public static final int FLASHCARD_TERM_MAX_LENGTH = 300;
    public static final int FLASHCARD_FRONT_TEXT_MAX_LENGTH = FLASHCARD_TERM_MAX_LENGTH;
    public static final int FLASHCARD_BACK_TEXT_MAX_LENGTH = 2000;
    public static final int LANGUAGE_CODE_MAX_LENGTH = 16;
    public static final int DESCRIPTION_MAX_LENGTH = 400;
    public static final int PRONUNCIATION_MAX_LENGTH = 400;
}
