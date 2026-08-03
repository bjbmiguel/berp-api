CREATE TABLE access_role (
    id BIGINT PRIMARY KEY,
    code VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    created_by BIGINT NOT NULL,
    changed_by BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT unique_access_role_name UNIQUE (code)
);

CREATE INDEX idx_access_role_deleted ON access_role(deleted) WHERE deleted = FALSE;
