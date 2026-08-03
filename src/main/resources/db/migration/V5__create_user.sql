-- "users" table (plural) — "user" is a reserved word in several SQL dialects.
-- party_id: a Person (identity). Required when user_type=HUMAN, null when SYSTEM
-- (never create a fake Person to represent an integration/job).
-- tenant_party_id: the Organization (company) to which this account belongs. Always present.
-- managed_by: self-relationship, only for SYSTEM — points to the responsible HUMAN User
-- (governance: who to contact if the integration misbehaves).
-- description: textual identification of SYSTEM accounts (which do not have a Person/name).
-- user_name/email are unique PER COMPANY — accounts are independent per company.
CREATE TABLE users (
    id                      BIGINT PRIMARY KEY,
    party_id                BIGINT REFERENCES party (id),
    tenant_party_id         BIGINT NOT NULL REFERENCES party (id),
    access_role_id          BIGINT NOT NULL,
    managed_by              BIGINT REFERENCES users (id),
    user_type               INT NOT NULL CHECK (user_type IN (1, 2)),
    user_name               VARCHAR(25) NOT NULL,
    email                   VARCHAR(255),
    email_verified_at       TIMESTAMPTZ,
    password_hash           VARCHAR(255),
    mfa_enabled             BOOLEAN NOT NULL DEFAULT FALSE,
    description             VARCHAR(300),
    status                  INT NOT NULL DEFAULT 1 CHECK (status IN (1, 2, 3)),
    failed_login_attempts   INT NOT NULL DEFAULT 0,
    locked_until            TIMESTAMPTZ,
    created_by              BIGINT NOT NULL,
    changed_by              BIGINT NOT NULL,
    created_at               TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted                 BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT fk_users_access_role FOREIGN KEY (access_role_id) REFERENCES access_role(id),
    CONSTRAINT uq_users_tenant_username UNIQUE (tenant_party_id, user_name),
    CONSTRAINT uq_users_tenant_email UNIQUE (tenant_party_id, email),
    CONSTRAINT chk_user_party_matches_type CHECK (
        (user_type = 1 AND party_id IS NOT NULL)  -- HUMAN
        OR (user_type = 2 AND party_id IS NULL)   -- SYSTEM
    )
);

COMMENT ON COLUMN users.user_type IS '1=HUMAN, 2=SYSTEM';
COMMENT ON COLUMN users.status IS '1=PENDING, 2=ACTIVE, 3=BLOCKED (administrative decision)';
COMMENT ON COLUMN users.email IS 'Verification/contact only — login is always by username, never by email';
COMMENT ON COLUMN users.managed_by IS 'Only for SYSTEM: HUMAN user responsible for this account. Validated in the application (cannot guarantee via CHECK that the referenced user is HUMAN)';
COMMENT ON COLUMN users.locked_until IS 'Automatic and temporary lock (failed attempts), regardless of status. Locked = locked_until not null AND in the future. Auto-expires, without needing a job.';
COMMENT ON COLUMN users.failed_login_attempts IS 'Reset to 0 on successful login';

CREATE INDEX idx_users_party ON users (party_id);
CREATE INDEX idx_users_tenant ON users (tenant_party_id);
CREATE INDEX idx_users_access_role ON users (access_role_id);
CREATE INDEX idx_users_managed_by ON users (managed_by);
CREATE INDEX idx_users_user_type ON users (user_type);
CREATE INDEX idx_users_status ON users (status);
CREATE INDEX idx_users_deleted ON users (deleted) WHERE deleted = FALSE;
CREATE INDEX idx_users_email ON users (email) WHERE email IS NOT NULL;
CREATE INDEX idx_users_locked ON users (locked_until) WHERE locked_until IS NOT NULL;
