INSERT INTO memora.user_accounts (
    id,
    username,
    email,
    password_hash,
    account_status,
    deleted_at,
    created_at,
    updated_at,
    version
) VALUES (
    1,
    'demo',
    'demo@memora.local',
    'demo-password-hash',
    'ACTIVE',
    NULL,
    NOW(),
    NOW(),
    0
)
ON CONFLICT (id) DO NOTHING;

SELECT setval(
    pg_get_serial_sequence('memora.user_accounts', 'id'),
    (SELECT COALESCE(MAX(id), 1) FROM memora.user_accounts),
    TRUE
);
