package com.memora.app.constant;

import lombok.experimental.UtilityClass;

@UtilityClass
public class ApiMessageKey {

    public static final String VALIDATION_ERROR = "api.error.validation";
    public static final String REQUEST_BODY_INVALID = "api.error.request.body.invalid";
    public static final String DATA_CONFLICT = "api.error.data.conflict";
    public static final String INTERNAL_ERROR = "api.error.internal";

    public static final String USER_ACCOUNT_ID_POSITIVE = "api.error.validation.user-account-id.positive";
    public static final String USER_ID_POSITIVE = "api.error.validation.user-id.positive";
    public static final String OWNER_USER_ID_POSITIVE = "api.error.validation.owner-user-id.positive";
    public static final String PARENT_ID_POSITIVE = "api.error.validation.parent-id.positive";
    public static final String FOLDER_ID_POSITIVE = "api.error.validation.folder-id.positive";
    public static final String DECK_ID_POSITIVE = "api.error.validation.deck-id.positive";
    public static final String FLASHCARD_ID_POSITIVE = "api.error.validation.flashcard-id.positive";
    public static final String FLASHCARD_LANGUAGE_ID_POSITIVE = "api.error.validation.flashcard-language-id.positive";
    public static final String REVIEW_PROFILE_ID_POSITIVE = "api.error.validation.review-profile-id.positive";
    public static final String REVIEW_PROFILE_BOX_ID_POSITIVE = "api.error.validation.review-profile-box-id.positive";
    public static final String DECK_REVIEW_SETTINGS_ID_POSITIVE = "api.error.validation.deck-review-settings-id.positive";
    public static final String NAME_REQUIRED = "api.error.validation.name.required";
    public static final String USERNAME_REQUIRED = "api.error.validation.username.required";
    public static final String EMAIL_REQUIRED = "api.error.validation.email.required";
    public static final String PASSWORD_REQUIRED = "api.error.validation.password.required";
    public static final String TERM_REQUIRED = "api.error.validation.term.required";
    public static final String MEANING_REQUIRED = "api.error.validation.meaning.required";
    public static final String LANGUAGE_CODE_REQUIRED = "api.error.validation.language-code.required";

    public static final String USER_ACCOUNT_NOT_FOUND = "api.error.user-account.not-found";
    public static final String FOLDER_NOT_FOUND = "api.error.folder.not-found";
    public static final String DECK_NOT_FOUND = "api.error.deck.not-found";
    public static final String FLASHCARD_NOT_FOUND = "api.error.flashcard.not-found";
    public static final String FLASHCARD_LANGUAGE_NOT_FOUND = "api.error.flashcard-language.not-found";
    public static final String REVIEW_PROFILE_NOT_FOUND = "api.error.review-profile.not-found";
    public static final String REVIEW_PROFILE_BOX_NOT_FOUND = "api.error.review-profile-box.not-found";
    public static final String DECK_REVIEW_SETTINGS_NOT_FOUND = "api.error.deck-review-settings.not-found";

    public static final String USER_ACCOUNT_DELETE_HAS_ACTIVE_FOLDERS = "api.error.user-account.delete.has-active-folders";
    public static final String USER_ACCOUNT_DELETE_HAS_CUSTOM_REVIEW_PROFILES =
        "api.error.user-account.delete.has-custom-review-profiles";
    public static final String USERNAME_EXISTS = "api.error.user-account.username.exists";
    public static final String EMAIL_EXISTS = "api.error.user-account.email.exists";
    public static final String FOLDER_DELETE_HAS_CHILD_FOLDERS = "api.error.folder.delete.has-child-folders";
    public static final String FOLDER_DELETE_HAS_ACTIVE_DECKS = "api.error.folder.delete.has-active-decks";
    public static final String FOLDER_PARENT_USER_MISMATCH = "api.error.folder.parent.user-mismatch";
    public static final String FOLDER_PARENT_SELF = "api.error.folder.parent.self";
    public static final String FOLDER_NAME_EXISTS = "api.error.folder.name.exists";
    public static final String FOLDER_CYCLE = "api.error.folder.cycle";
    public static final String DECK_NAME_EXISTS = "api.error.deck.name.exists";
    public static final String FLASHCARD_LANGUAGE_SIDE_EXISTS = "api.error.flashcard-language.side.exists";
    public static final String REVIEW_PROFILE_SYSTEM_LOCKED = "api.error.review-profile.system.locked";
    public static final String REVIEW_PROFILE_NAME_EXISTS = "api.error.review-profile.name.exists";
    public static final String REVIEW_PROFILE_BOX_SYSTEM_LOCKED = "api.error.review-profile-box.system.locked";
    public static final String REVIEW_PROFILE_BOX_NUMBER_EXISTS = "api.error.review-profile-box.number.exists";
    public static final String DECK_REVIEW_SETTINGS_EXISTS = "api.error.deck-review-settings.exists";
    public static final String DECK_REVIEW_SETTINGS_REVIEW_PROFILE_USER_MISMATCH =
        "api.error.deck-review-settings.review-profile.user-mismatch";
}
