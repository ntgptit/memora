-- =========================================================
-- MEMORA DATABASE - INITIAL SCHEMA
-- Compatible with Spring Boot + JPA + Flyway
-- PostgreSQL is the source-of-truth database for this service.
-- =========================================================

-- =========================================================
-- ENUM-LIKE VALUES
-- Enforced with VARCHAR columns plus CHECK constraints for
-- better JPA/Hibernate portability.
-- =========================================================

-- =========================================================
-- USER ACCOUNTS
-- =========================================================

CREATE TABLE memora.user_accounts (
    id                  BIGSERIAL PRIMARY KEY,
    username            VARCHAR(40) NOT NULL,
    email               VARCHAR(120) NOT NULL,
    password_hash       VARCHAR(240) NOT NULL,
    account_status      VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    deleted_at          TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version             BIGINT NOT NULL DEFAULT 0,

    CONSTRAINT chk_user_accounts_account_status
        CHECK (account_status IN ('ACTIVE', 'PENDING', 'LOCKED', 'DISABLED'))
);

CREATE UNIQUE INDEX uq_user_accounts_username_active
ON memora.user_accounts (LOWER(username))
WHERE deleted_at IS NULL;

CREATE UNIQUE INDEX uq_user_accounts_email_active
ON memora.user_accounts (LOWER(email))
WHERE deleted_at IS NULL;

-- =========================================================
-- FOLDERS (Adjacency list)
-- =========================================================

CREATE TABLE memora.folders (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT NOT NULL,
    parent_id       BIGINT,
    name            VARCHAR(150) NOT NULL,
    description     VARCHAR(400) NOT NULL DEFAULT '',
    depth           INT NOT NULL DEFAULT 0,
    deleted_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version         BIGINT NOT NULL DEFAULT 0,

    CONSTRAINT uq_folders_id_user
        UNIQUE (id, user_id),

    CONSTRAINT fk_folders_user
        FOREIGN KEY (user_id) REFERENCES memora.user_accounts(id),

    CONSTRAINT fk_folders_parent
        FOREIGN KEY (parent_id, user_id) REFERENCES memora.folders(id, user_id),

    CONSTRAINT chk_folders_depth
        CHECK (depth >= 0),

    CONSTRAINT chk_folders_parent_self
        CHECK (parent_id IS NULL OR parent_id <> id)
);

CREATE INDEX idx_folders_user_id ON memora.folders(user_id);
CREATE INDEX idx_folders_parent_id ON memora.folders(parent_id);

CREATE UNIQUE INDEX uq_folders_user_parent_name_active
ON memora.folders (user_id, COALESCE(parent_id, 0), LOWER(name))
WHERE deleted_at IS NULL;

-- =========================================================
-- DECKS
-- =========================================================

CREATE TABLE memora.decks (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT NOT NULL,
    folder_id       BIGINT NOT NULL,
    name            VARCHAR(120) NOT NULL,
    description     VARCHAR(400) NOT NULL DEFAULT '',
    deleted_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version         BIGINT NOT NULL DEFAULT 0,

    CONSTRAINT uq_decks_id_user
        UNIQUE (id, user_id),

    CONSTRAINT fk_decks_user
        FOREIGN KEY (user_id) REFERENCES memora.user_accounts(id),

    CONSTRAINT fk_decks_folder
        FOREIGN KEY (folder_id, user_id) REFERENCES memora.folders(id, user_id),

    CONSTRAINT chk_decks_name_not_blank
        CHECK (btrim(name) <> '')
);

CREATE INDEX idx_decks_user_id ON memora.decks(user_id);
CREATE INDEX idx_decks_folder_id ON memora.decks(folder_id);

CREATE UNIQUE INDEX uq_decks_folder_name_active
ON memora.decks (folder_id, LOWER(name))
WHERE deleted_at IS NULL;

-- =========================================================
-- FLASHCARDS
-- =========================================================

CREATE TABLE memora.flashcards (
    id                  BIGSERIAL PRIMARY KEY,
    deck_id             BIGINT NOT NULL,
    term                VARCHAR(300) NOT NULL,
    meaning             TEXT NOT NULL,
    note                TEXT NOT NULL DEFAULT '',
    is_bookmarked       BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version             BIGINT NOT NULL DEFAULT 0,

    CONSTRAINT fk_flashcards_deck
        FOREIGN KEY (deck_id) REFERENCES memora.decks(id),

    CONSTRAINT chk_flashcards_term_not_blank
        CHECK (btrim(term) <> ''),

    CONSTRAINT chk_flashcards_meaning_not_blank
        CHECK (btrim(meaning) <> '')
);

CREATE INDEX idx_flashcards_deck_id ON memora.flashcards(deck_id);

-- =========================================================
-- FLASHCARD SIDE LANGUAGES
-- =========================================================

CREATE TABLE memora.flashcard_languages (
    id                  BIGSERIAL PRIMARY KEY,
    flashcard_id        BIGINT NOT NULL,
    side                VARCHAR(20) NOT NULL,
    language_code       VARCHAR(16) NOT NULL,
    pronunciation       VARCHAR(400) NOT NULL DEFAULT '',
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version             BIGINT NOT NULL DEFAULT 0,

    CONSTRAINT fk_flashcard_languages_flashcard
        FOREIGN KEY (flashcard_id) REFERENCES memora.flashcards(id),

    CONSTRAINT chk_flashcard_languages_language_code_not_blank
        CHECK (btrim(language_code) <> ''),

    CONSTRAINT chk_flashcard_languages_side
        CHECK (side IN ('TERM', 'MEANING'))
);

CREATE INDEX idx_flashcard_languages_flashcard_id
ON memora.flashcard_languages(flashcard_id);

CREATE INDEX idx_flashcard_languages_language_code
ON memora.flashcard_languages(language_code);

CREATE UNIQUE INDEX uq_flashcard_languages_flashcard_side
ON memora.flashcard_languages(flashcard_id, side);

-- =========================================================
-- REFRESH TOKENS
-- =========================================================

CREATE TABLE memora.refresh_tokens (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT NOT NULL,
    token_hash      VARCHAR(128) NOT NULL,
    token_status    VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    expires_at      TIMESTAMPTZ NOT NULL,
    revoked_at      TIMESTAMPTZ,
    device_label    VARCHAR(120),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version         BIGINT NOT NULL DEFAULT 0,

    CONSTRAINT fk_refresh_tokens_user
        FOREIGN KEY (user_id) REFERENCES memora.user_accounts(id),

    CONSTRAINT chk_refresh_tokens_token_status
        CHECK (token_status IN ('ACTIVE', 'REVOKED', 'EXPIRED')),

    CONSTRAINT chk_refresh_tokens_expires_after_create
        CHECK (expires_at > created_at),

    CONSTRAINT chk_refresh_tokens_active_not_revoked
        CHECK (token_status <> 'ACTIVE' OR revoked_at IS NULL),

    CONSTRAINT chk_refresh_tokens_revoked_has_timestamp
        CHECK (token_status <> 'REVOKED' OR revoked_at IS NOT NULL)
);

CREATE UNIQUE INDEX uq_refresh_tokens_token_hash
ON memora.refresh_tokens(token_hash);

CREATE INDEX idx_refresh_tokens_user_status
ON memora.refresh_tokens(user_id, token_status);

-- =========================================================
-- REVIEW PROFILES
-- =========================================================

CREATE TABLE memora.review_profiles (
    id                          BIGSERIAL PRIMARY KEY,
    owner_user_id               BIGINT,
    name                        VARCHAR(120) NOT NULL,
    description                 VARCHAR(400) NOT NULL DEFAULT '',
    algorithm_type              VARCHAR(20) NOT NULL DEFAULT 'LEITNER_7',
    is_system                   BOOLEAN NOT NULL DEFAULT FALSE,
    is_default                  BOOLEAN NOT NULL DEFAULT FALSE,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version                     BIGINT NOT NULL DEFAULT 0,

    CONSTRAINT fk_review_profiles_owner
        FOREIGN KEY (owner_user_id) REFERENCES memora.user_accounts(id),

    CONSTRAINT chk_review_profiles_algorithm_type
        CHECK (algorithm_type IN ('LEITNER_7')),

    CONSTRAINT chk_review_profiles_name_not_blank
        CHECK (btrim(name) <> ''),

    CONSTRAINT chk_review_profiles_scope
        CHECK (
            (is_system = TRUE AND owner_user_id IS NULL)
            OR
            (is_system = FALSE AND owner_user_id IS NOT NULL)
        )
);

CREATE INDEX idx_review_profiles_owner_user_id
ON memora.review_profiles(owner_user_id);

CREATE UNIQUE INDEX uq_review_profiles_owner_name_active
ON memora.review_profiles (COALESCE(owner_user_id, 0), LOWER(name));

CREATE UNIQUE INDEX uq_review_profiles_owner_default_active
ON memora.review_profiles (COALESCE(owner_user_id, 0))
WHERE is_default = TRUE;

-- =========================================================
-- REVIEW PROFILE BOXES
-- =========================================================

CREATE TABLE memora.review_profile_boxes (
    id                          BIGSERIAL PRIMARY KEY,
    review_profile_id           BIGINT NOT NULL,
    box_number                  INT NOT NULL,
    interval_seconds            BIGINT NOT NULL,
    incorrect_box_number        INT NOT NULL,
    correct_box_number          INT NOT NULL,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version                     BIGINT NOT NULL DEFAULT 0,

    CONSTRAINT uq_review_profile_boxes_profile_box
        UNIQUE (review_profile_id, box_number),

    CONSTRAINT fk_review_profile_boxes_profile
        FOREIGN KEY (review_profile_id) REFERENCES memora.review_profiles(id),

    CONSTRAINT chk_review_profile_boxes_box_number
        CHECK (box_number >= 1),

    CONSTRAINT chk_review_profile_boxes_interval_seconds
        CHECK (interval_seconds >= 0),

    CONSTRAINT chk_review_profile_boxes_targets
        CHECK (
            incorrect_box_number >= 1
            AND correct_box_number >= 1
        )
);

CREATE INDEX idx_review_profile_boxes_profile_id
ON memora.review_profile_boxes(review_profile_id);

-- =========================================================
-- DECK REVIEW SETTINGS
-- =========================================================

CREATE TABLE memora.deck_review_settings (
    id                          BIGSERIAL PRIMARY KEY,
    deck_id                     BIGINT NOT NULL,
    review_profile_id           BIGINT NOT NULL,
    new_cards_per_day           INT NOT NULL DEFAULT 20,
    reviews_per_day             INT NOT NULL DEFAULT 200,
    bury_siblings               BOOLEAN NOT NULL DEFAULT FALSE,
    leech_threshold             INT NOT NULL DEFAULT 8,
    suspend_leech_cards         BOOLEAN NOT NULL DEFAULT TRUE,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version                     BIGINT NOT NULL DEFAULT 0,

    CONSTRAINT fk_deck_review_settings_deck
        FOREIGN KEY (deck_id) REFERENCES memora.decks(id),

    CONSTRAINT fk_deck_review_settings_profile
        FOREIGN KEY (review_profile_id) REFERENCES memora.review_profiles(id),

    CONSTRAINT chk_deck_review_settings_new_cards_per_day
        CHECK (new_cards_per_day >= 0),

    CONSTRAINT chk_deck_review_settings_reviews_per_day
        CHECK (reviews_per_day >= 0),

    CONSTRAINT chk_deck_review_settings_leech_threshold
        CHECK (leech_threshold >= 1)
);

CREATE INDEX idx_deck_review_settings_profile_id
ON memora.deck_review_settings(review_profile_id);

CREATE UNIQUE INDEX uq_deck_review_settings_deck
ON memora.deck_review_settings(deck_id);

-- =========================================================
-- REVIEW CARD STATES
-- =========================================================

CREATE TABLE memora.review_card_states (
    id                          BIGSERIAL PRIMARY KEY,
    user_id                     BIGINT NOT NULL,
    flashcard_id                BIGINT NOT NULL,
    review_profile_id           BIGINT NOT NULL,
    state_status                VARCHAR(20) NOT NULL DEFAULT 'NEW',
    current_box_number          INT NOT NULL DEFAULT 1,
    due_at                      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_reviewed_at            TIMESTAMPTZ,
    last_outcome                VARCHAR(20),
    success_streak              INT NOT NULL DEFAULT 0,
    lapse_count                 INT NOT NULL DEFAULT 0,
    review_count                INT NOT NULL DEFAULT 0,
    suspended_at                TIMESTAMPTZ,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version                     BIGINT NOT NULL DEFAULT 0,

    CONSTRAINT fk_review_card_states_user
        FOREIGN KEY (user_id) REFERENCES memora.user_accounts(id),

    CONSTRAINT fk_review_card_states_flashcard
        FOREIGN KEY (flashcard_id) REFERENCES memora.flashcards(id),

    CONSTRAINT fk_review_card_states_profile
        FOREIGN KEY (review_profile_id) REFERENCES memora.review_profiles(id),

    CONSTRAINT chk_review_card_states_current_box_number
        CHECK (current_box_number >= 1),

    CONSTRAINT chk_review_card_states_success_streak
        CHECK (success_streak >= 0),

    CONSTRAINT chk_review_card_states_state_status
        CHECK (state_status IN ('NEW', 'LEARNING', 'REVIEW', 'RELEARNING', 'SUSPENDED')),

    CONSTRAINT chk_review_card_states_last_outcome
        CHECK (
            last_outcome IS NULL
            OR last_outcome IN ('CORRECT', 'INCORRECT')
        ),

    CONSTRAINT chk_review_card_states_last_review_pair
        CHECK (last_outcome IS NULL OR last_reviewed_at IS NOT NULL),

    CONSTRAINT chk_review_card_states_lapse_count
        CHECK (lapse_count >= 0),

    CONSTRAINT chk_review_card_states_review_count
        CHECK (review_count >= 0),

    CONSTRAINT chk_review_card_states_suspension
        CHECK (
            (state_status = 'SUSPENDED' AND suspended_at IS NOT NULL)
            OR
            (state_status <> 'SUSPENDED' AND suspended_at IS NULL)
        ),

    CONSTRAINT chk_review_card_states_new_state_shape
        CHECK (
            state_status <> 'NEW'
            OR
            (
                current_box_number = 1
                AND last_reviewed_at IS NULL
                AND last_outcome IS NULL
                AND success_streak = 0
                AND lapse_count = 0
                AND review_count = 0
            )
        )
);

CREATE UNIQUE INDEX uq_review_card_states_user_flashcard
ON memora.review_card_states(user_id, flashcard_id);

CREATE INDEX idx_review_card_states_user_due_at
ON memora.review_card_states(user_id, state_status, due_at);

CREATE INDEX idx_review_card_states_profile_id
ON memora.review_card_states(review_profile_id);

CREATE FUNCTION memora.has_exact_study_modes(
    p_mode_plan JSONB,
    p_expected_modes TEXT[]
)
RETURNS BOOLEAN
LANGUAGE SQL
IMMUTABLE
AS $$
    SELECT
        jsonb_typeof(p_mode_plan) = 'array'
        AND jsonb_array_length(p_mode_plan) = cardinality(p_expected_modes)
        AND NOT EXISTS (
            SELECT 1
            FROM jsonb_array_elements_text(p_mode_plan) AS actual(mode)
            GROUP BY actual.mode
            HAVING COUNT(*) > 1 OR NOT (actual.mode = ANY (p_expected_modes))
        )
        AND NOT EXISTS (
            SELECT 1
            FROM unnest(p_expected_modes) AS expected(mode)
            WHERE NOT EXISTS (
                SELECT 1
                FROM jsonb_array_elements_text(p_mode_plan) AS actual(mode)
                WHERE actual.mode = expected.mode
            )
        );
$$;

-- =========================================================
-- STUDY SESSIONS
-- =========================================================

CREATE TABLE memora.study_sessions (
    id                      BIGSERIAL PRIMARY KEY,
    user_id                 BIGINT NOT NULL,
    deck_id                 BIGINT NOT NULL,
    review_profile_id       BIGINT,
    session_type            VARCHAR(20) NOT NULL,
    mode_plan               JSONB NOT NULL DEFAULT '[]'::jsonb,
    current_mode_index      INT NOT NULL DEFAULT 0,
    session_state           VARCHAR(20) NOT NULL,
    current_item_index      INT NOT NULL DEFAULT 0,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version                 BIGINT NOT NULL DEFAULT 0,

    CONSTRAINT fk_study_sessions_user
        FOREIGN KEY (user_id) REFERENCES memora.user_accounts(id),

    CONSTRAINT fk_study_sessions_deck
        FOREIGN KEY (deck_id, user_id) REFERENCES memora.decks(id, user_id),

    CONSTRAINT fk_study_sessions_review_profile
        FOREIGN KEY (review_profile_id) REFERENCES memora.review_profiles(id),

    CONSTRAINT chk_study_sessions_session_type
        CHECK (session_type IN ('LEARN', 'REVIEW')),

    CONSTRAINT chk_study_sessions_session_state
        CHECK (session_state IN ('PENDING', 'RUNNING', 'COMPLETED')),

    CONSTRAINT chk_study_sessions_mode_plan_array
        CHECK (jsonb_typeof(mode_plan) = 'array'),

    CONSTRAINT chk_study_sessions_current_mode_index
        CHECK (current_mode_index >= 0),

    CONSTRAINT chk_study_sessions_current_item_index
        CHECK (current_item_index >= 0),

    CONSTRAINT chk_study_sessions_review_profile_usage
        CHECK (
            (session_type = 'REVIEW' AND review_profile_id IS NOT NULL)
            OR
            (session_type = 'LEARN' AND review_profile_id IS NULL)
        ),

    CONSTRAINT chk_study_sessions_pending_position
        CHECK (
            session_state <> 'PENDING'
            OR
            (current_mode_index = 0 AND current_item_index = 0)
        ),

    CONSTRAINT chk_study_sessions_mode_plan_matches_type
        CHECK (
            (session_type = 'LEARN'
                AND memora.has_exact_study_modes(
                    mode_plan,
                    ARRAY['REVIEW', 'MATCH', 'GUESS', 'RECALL', 'FILL']
                )
            )
            OR
            (session_type = 'REVIEW' AND mode_plan = '["FILL"]'::jsonb)
        ),

    CONSTRAINT chk_study_sessions_current_mode_in_plan
        CHECK (
            jsonb_typeof(mode_plan) <> 'array'
            OR jsonb_array_length(mode_plan) = 0
            OR current_mode_index < jsonb_array_length(mode_plan)
        )
);

CREATE INDEX idx_study_sessions_user_id ON memora.study_sessions(user_id);
CREATE INDEX idx_study_sessions_deck_id ON memora.study_sessions(deck_id);
CREATE INDEX idx_study_sessions_review_profile_id ON memora.study_sessions(review_profile_id);

-- =========================================================
-- STUDY SESSION ITEMS
-- =========================================================

CREATE TABLE memora.study_session_items (
    id                          BIGSERIAL PRIMARY KEY,
    study_session_id            BIGINT NOT NULL,
    flashcard_id                BIGINT NOT NULL,
    sequence_index              INT NOT NULL,
    term_snapshot               TEXT NOT NULL,
    meaning_snapshot            TEXT NOT NULL,
    note_snapshot               TEXT NOT NULL,
    term_pronunciation_snapshot TEXT NOT NULL DEFAULT '',
    meaning_pronunciation_snapshot TEXT NOT NULL DEFAULT '',
    last_outcome                VARCHAR(20),
    current_mode_completed      BOOLEAN NOT NULL DEFAULT FALSE,
    retry_pending               BOOLEAN NOT NULL DEFAULT FALSE,
    incorrect_attempt_count     INT NOT NULL DEFAULT 0,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    version                     BIGINT NOT NULL DEFAULT 0,

    CONSTRAINT fk_ssi_session
        FOREIGN KEY (study_session_id) REFERENCES memora.study_sessions(id),

    CONSTRAINT fk_ssi_flashcard
        FOREIGN KEY (flashcard_id) REFERENCES memora.flashcards(id),

    CONSTRAINT chk_study_session_items_last_outcome
        CHECK (
            last_outcome IS NULL
            OR last_outcome IN ('CORRECT', 'INCORRECT')
        ),

    CONSTRAINT chk_study_session_items_sequence_index
        CHECK (sequence_index >= 0),

    CONSTRAINT chk_study_session_items_incorrect_attempt_count
        CHECK (incorrect_attempt_count >= 0),

    CONSTRAINT uq_ssi_session_sequence
        UNIQUE (study_session_id, sequence_index)
);

CREATE INDEX idx_ssi_flashcard_id ON memora.study_session_items(flashcard_id);

-- =========================================================
-- STUDY ATTEMPTS
-- =========================================================

CREATE TABLE memora.study_attempts (
    id                  BIGSERIAL PRIMARY KEY,
    study_session_id    BIGINT NOT NULL,
    flashcard_id        BIGINT NOT NULL,
    study_mode          VARCHAR(30) NOT NULL,
    review_outcome      VARCHAR(20) NOT NULL,
    submitted_answer    TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_attempts_session
        FOREIGN KEY (study_session_id) REFERENCES memora.study_sessions(id),

    CONSTRAINT fk_attempts_flashcard
        FOREIGN KEY (flashcard_id) REFERENCES memora.flashcards(id),

    CONSTRAINT chk_study_attempts_study_mode
        CHECK (study_mode IN ('REVIEW', 'MATCH', 'GUESS', 'RECALL', 'FILL')),

    CONSTRAINT chk_study_attempts_review_outcome
        CHECK (review_outcome IN ('CORRECT', 'INCORRECT'))
);

CREATE INDEX idx_study_attempts_session
ON memora.study_attempts(study_session_id);

CREATE INDEX idx_study_attempts_flashcard_id
ON memora.study_attempts(flashcard_id);

-- =========================================================
-- REVIEW EVENTS
-- =========================================================

CREATE TABLE memora.review_events (
    id                          BIGSERIAL PRIMARY KEY,
    user_id                     BIGINT NOT NULL,
    flashcard_id                BIGINT NOT NULL,
    review_profile_id           BIGINT NOT NULL,
    study_attempt_id            BIGINT,
    event_type                  VARCHAR(30) NOT NULL DEFAULT 'ATTEMPT',
    state_status_before         VARCHAR(20),
    state_status_after          VARCHAR(20) NOT NULL,
    box_before                  INT,
    box_after                   INT NOT NULL,
    due_at_before               TIMESTAMPTZ,
    due_at_after                TIMESTAMPTZ NOT NULL,
    review_outcome              VARCHAR(20),
    interval_seconds_applied    BIGINT,
    algorithm_snapshot_json     JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_review_events_user
        FOREIGN KEY (user_id) REFERENCES memora.user_accounts(id),

    CONSTRAINT fk_review_events_flashcard
        FOREIGN KEY (flashcard_id) REFERENCES memora.flashcards(id),

    CONSTRAINT fk_review_events_profile
        FOREIGN KEY (review_profile_id) REFERENCES memora.review_profiles(id),

    CONSTRAINT fk_review_events_study_attempt
        FOREIGN KEY (study_attempt_id) REFERENCES memora.study_attempts(id),

    CONSTRAINT chk_review_events_box_before
        CHECK (box_before IS NULL OR box_before >= 1),

    CONSTRAINT chk_review_events_box_after
        CHECK (box_after >= 1),

    CONSTRAINT chk_review_events_event_type
        CHECK (event_type IN ('ATTEMPT', 'MANUAL_RESCHEDULE', 'PROFILE_CHANGED', 'RESET', 'SUSPEND', 'UNSUSPEND')),

    CONSTRAINT chk_review_events_state_status_before
        CHECK (
            state_status_before IS NULL
            OR state_status_before IN ('NEW', 'LEARNING', 'REVIEW', 'RELEARNING', 'SUSPENDED')
        ),

    CONSTRAINT chk_review_events_state_status_after
        CHECK (state_status_after IN ('NEW', 'LEARNING', 'REVIEW', 'RELEARNING', 'SUSPENDED')),

    CONSTRAINT chk_review_events_review_outcome
        CHECK (
            review_outcome IS NULL
            OR review_outcome IN ('CORRECT', 'INCORRECT')
        ),

    CONSTRAINT chk_review_events_interval_seconds_applied
        CHECK (interval_seconds_applied IS NULL OR interval_seconds_applied >= 0),

    CONSTRAINT chk_review_events_attempt_shape
        CHECK (
            (event_type = 'ATTEMPT' AND study_attempt_id IS NOT NULL AND review_outcome IS NOT NULL)
            OR
            (event_type <> 'ATTEMPT' AND study_attempt_id IS NULL)
        ),

    CONSTRAINT chk_review_events_non_attempt_outcome
        CHECK (event_type = 'ATTEMPT' OR review_outcome IS NULL),

    CONSTRAINT chk_review_events_suspend_transition
        CHECK (event_type <> 'SUSPEND' OR state_status_after = 'SUSPENDED'),

    CONSTRAINT chk_review_events_unsuspend_transition
        CHECK (
            event_type <> 'UNSUSPEND'
            OR
            (state_status_before = 'SUSPENDED' AND state_status_after <> 'SUSPENDED')
        ),

    CONSTRAINT chk_review_events_reset_transition
        CHECK (event_type <> 'RESET' OR box_after = 1)
);

CREATE INDEX idx_review_events_user_created_at
ON memora.review_events(user_id, created_at);

CREATE INDEX idx_review_events_flashcard_created_at
ON memora.review_events(flashcard_id, created_at);

CREATE UNIQUE INDEX uq_review_events_study_attempt_id
ON memora.review_events(study_attempt_id)
WHERE study_attempt_id IS NOT NULL;

ALTER TABLE memora.review_profile_boxes
    ADD CONSTRAINT fk_review_profile_boxes_incorrect_box
        FOREIGN KEY (review_profile_id, incorrect_box_number)
        REFERENCES memora.review_profile_boxes(review_profile_id, box_number)
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE memora.review_profile_boxes
    ADD CONSTRAINT fk_review_profile_boxes_correct_box
        FOREIGN KEY (review_profile_id, correct_box_number)
        REFERENCES memora.review_profile_boxes(review_profile_id, box_number)
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE memora.review_card_states
    ADD CONSTRAINT fk_review_card_states_current_box
        FOREIGN KEY (review_profile_id, current_box_number)
        REFERENCES memora.review_profile_boxes(review_profile_id, box_number);

ALTER TABLE memora.review_events
    ADD CONSTRAINT fk_review_events_box_before
        FOREIGN KEY (review_profile_id, box_before)
        REFERENCES memora.review_profile_boxes(review_profile_id, box_number);

ALTER TABLE memora.review_events
    ADD CONSTRAINT fk_review_events_box_after
        FOREIGN KEY (review_profile_id, box_after)
        REFERENCES memora.review_profile_boxes(review_profile_id, box_number);

-- =========================================================
-- DEFAULT REVIEW PROFILE SEED
-- =========================================================

INSERT INTO memora.review_profiles (
    id,
    owner_user_id,
    name,
    description,
    algorithm_type,
    is_system,
    is_default
) VALUES (
    1,
    NULL,
    'Leitner 7-box default',
    'System default SRS profile with seven configurable boxes.',
    'LEITNER_7',
    TRUE,
    TRUE
);

SELECT setval(
    pg_get_serial_sequence('memora.review_profiles', 'id'),
    (SELECT MAX(id) FROM memora.review_profiles),
    TRUE
);

INSERT INTO memora.review_profile_boxes (
    review_profile_id,
    box_number,
    interval_seconds,
    incorrect_box_number,
    correct_box_number
) VALUES
    (1, 1, 600, 1, 2),
    (1, 2, 86400, 1, 3),
    (1, 3, 259200, 2, 4),
    (1, 4, 604800, 3, 5),
    (1, 5, 1209600, 4, 6),
    (1, 6, 2592000, 5, 7),
    (1, 7, 5184000, 6, 7);

-- =========================================================
-- OWNERSHIP AND STATE VALIDATION
-- =========================================================

CREATE FUNCTION memora.assert_review_profile_access(
    p_review_profile_id BIGINT,
    p_user_id BIGINT,
    p_context TEXT
)
RETURNS VOID AS $$
BEGIN
    IF p_review_profile_id IS NULL THEN
        RETURN;
    END IF;

    IF EXISTS (
        SELECT 1
        FROM memora.review_profiles review_profile
        WHERE review_profile.id = p_review_profile_id
          AND (
              review_profile.is_system = TRUE
              OR review_profile.owner_user_id = p_user_id
          )
    ) THEN
        RETURN;
    END IF;

    RAISE EXCEPTION '% references review_profile_id % outside the allowed scope for user %',
        p_context,
        p_review_profile_id,
        p_user_id;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION memora.assert_flashcard_owned_by_user(
    p_flashcard_id BIGINT,
    p_user_id BIGINT,
    p_context TEXT
)
RETURNS VOID AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM memora.flashcards flashcard
        INNER JOIN memora.decks deck
            ON deck.id = flashcard.deck_id
        WHERE flashcard.id = p_flashcard_id
          AND deck.user_id = p_user_id
    ) THEN
        RETURN;
    END IF;

    RAISE EXCEPTION '% references flashcard_id % outside the allowed scope for user %',
        p_context,
        p_flashcard_id,
        p_user_id;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION memora.assert_flashcard_in_session_deck(
    p_flashcard_id BIGINT,
    p_study_session_id BIGINT,
    p_context TEXT
)
RETURNS VOID AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM memora.study_sessions study_session
        INNER JOIN memora.flashcards flashcard
            ON flashcard.deck_id = study_session.deck_id
        WHERE study_session.id = p_study_session_id
          AND flashcard.id = p_flashcard_id
    ) THEN
        RETURN;
    END IF;

    RAISE EXCEPTION '% references flashcard_id % that does not belong to study_session_id %',
        p_context,
        p_flashcard_id,
        p_study_session_id;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION memora.validate_deck_review_settings()
RETURNS TRIGGER AS $$
DECLARE
    v_deck_user_id BIGINT;
BEGIN
    SELECT deck.user_id
    INTO v_deck_user_id
    FROM memora.decks deck
    WHERE deck.id = NEW.deck_id;

    PERFORM memora.assert_review_profile_access(
        NEW.review_profile_id,
        v_deck_user_id,
        'deck_review_settings'
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION memora.validate_review_card_states()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM memora.assert_flashcard_owned_by_user(
        NEW.flashcard_id,
        NEW.user_id,
        'review_card_states'
    );

    PERFORM memora.assert_review_profile_access(
        NEW.review_profile_id,
        NEW.user_id,
        'review_card_states'
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION memora.validate_study_sessions()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM memora.assert_review_profile_access(
        NEW.review_profile_id,
        NEW.user_id,
        'study_sessions'
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION memora.validate_study_session_items()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM memora.assert_flashcard_in_session_deck(
        NEW.flashcard_id,
        NEW.study_session_id,
        'study_session_items'
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION memora.validate_study_attempts()
RETURNS TRIGGER AS $$
DECLARE
    v_session_type TEXT;
    v_mode_plan JSONB;
BEGIN
    SELECT study_session.session_type, study_session.mode_plan
    INTO v_session_type, v_mode_plan
    FROM memora.study_sessions study_session
    WHERE study_session.id = NEW.study_session_id;

    PERFORM memora.assert_flashcard_in_session_deck(
        NEW.flashcard_id,
        NEW.study_session_id,
        'study_attempts'
    );

    IF v_session_type = 'REVIEW' AND NEW.study_mode <> 'FILL' THEN
        RAISE EXCEPTION
            'study_attempts for review sessions must use FILL mode, received %',
            NEW.study_mode;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM jsonb_array_elements_text(v_mode_plan) AS allowed_mode(mode)
        WHERE allowed_mode.mode = NEW.study_mode
    ) THEN
        RAISE EXCEPTION
            'study_attempts mode % is not part of study_session_id % mode_plan',
            NEW.study_mode,
            NEW.study_session_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION memora.validate_review_events()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM memora.assert_flashcard_owned_by_user(
        NEW.flashcard_id,
        NEW.user_id,
        'review_events'
    );

    PERFORM memora.assert_review_profile_access(
        NEW.review_profile_id,
        NEW.user_id,
        'review_events'
    );

    IF NEW.study_attempt_id IS NOT NULL
       AND NOT EXISTS (
           SELECT 1
           FROM memora.study_attempts study_attempt
           INNER JOIN memora.study_sessions study_session
               ON study_session.id = study_attempt.study_session_id
           WHERE study_attempt.id = NEW.study_attempt_id
             AND study_attempt.flashcard_id = NEW.flashcard_id
             AND study_session.user_id = NEW.user_id
       ) THEN
        RAISE EXCEPTION 'review_events references study_attempt_id % that does not match flashcard_id % and user_id %',
            NEW.study_attempt_id,
            NEW.flashcard_id,
            NEW.user_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_deck_review_settings_validate
    BEFORE INSERT OR UPDATE ON memora.deck_review_settings
    FOR EACH ROW
    EXECUTE FUNCTION memora.validate_deck_review_settings();

CREATE TRIGGER trg_review_card_states_validate
    BEFORE INSERT OR UPDATE ON memora.review_card_states
    FOR EACH ROW
    EXECUTE FUNCTION memora.validate_review_card_states();

CREATE TRIGGER trg_study_sessions_validate
    BEFORE INSERT OR UPDATE ON memora.study_sessions
    FOR EACH ROW
    EXECUTE FUNCTION memora.validate_study_sessions();

CREATE TRIGGER trg_study_session_items_validate
    BEFORE INSERT OR UPDATE ON memora.study_session_items
    FOR EACH ROW
    EXECUTE FUNCTION memora.validate_study_session_items();

CREATE TRIGGER trg_study_attempts_validate
    BEFORE INSERT OR UPDATE ON memora.study_attempts
    FOR EACH ROW
    EXECUTE FUNCTION memora.validate_study_attempts();

CREATE TRIGGER trg_review_events_validate
    BEFORE INSERT OR UPDATE ON memora.review_events
    FOR EACH ROW
    EXECUTE FUNCTION memora.validate_review_events();
