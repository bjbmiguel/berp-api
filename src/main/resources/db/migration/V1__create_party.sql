CREATE TABLE party (
    id           BIGINT PRIMARY KEY,
    party_type   INT NOT NULL,
    status       INT NOT NULL DEFAULT 1,
    created_by   BIGINT NOT NULL,
    changed_by   BIGINT NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted      BOOLEAN NOT NULL DEFAULT FALSE
);

COMMENT ON COLUMN party.party_type IS '1=PERSON, 2=ORGANIZATION';
COMMENT ON COLUMN party.status IS '1=ACTIVE, 2=INACTIVE, 3=BLOCKED';
COMMENT ON COLUMN party.deleted IS 'Soft delete';

-- created_by/changed_by WITHOUT FOREIGN KEY on purpose — avoids circular dependency
-- (users.party_id -> party.id, and party.created_by conceptually -> users.id).

CREATE INDEX idx_party_party_type ON party (party_type);
CREATE INDEX idx_party_status ON party (status);
CREATE INDEX idx_party_created_by ON party (created_by);
CREATE INDEX idx_party_changed_by ON party (changed_by);
CREATE INDEX idx_party_deleted ON party (deleted) WHERE deleted = FALSE;
