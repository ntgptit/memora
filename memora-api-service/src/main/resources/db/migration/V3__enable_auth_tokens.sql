ALTER TABLE memora.refresh_tokens
    DROP CONSTRAINT IF EXISTS chk_refresh_tokens_token_status;

ALTER TABLE memora.refresh_tokens
    ADD CONSTRAINT chk_refresh_tokens_token_status
        CHECK (token_status IN ('ACTIVE', 'ROTATED', 'REVOKED', 'EXPIRED'));

UPDATE memora.user_accounts
SET password_hash = '$2a$10$Dzxwu3G4oMnFKGbTlVIbjeA/b32ijSSN.mqTryB90/jj/M0LAO3ZG',
    updated_at = NOW()
WHERE id = 1
  AND username = 'demo'
  AND email = 'demo@memora.local';
