CREATE TABLE commune (
    -- Commune data
    id BIGINT PRIMARY KEY,
    municipality_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    alpha_code VARCHAR(50) NULL,
    deleted BOOLEAN NOT NULL DEFAULT FALSE,

    -- Audit
    created_by BIGINT NOT NULL,
    changed_by BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT fk_commune_municipality
        FOREIGN KEY (municipality_id) REFERENCES municipality(id),

    CONSTRAINT fk_commune_created_by
        FOREIGN KEY (created_by) REFERENCES users(id),

    CONSTRAINT fk_commune_changed_by
        FOREIGN KEY (changed_by) REFERENCES users(id),

    -- Uniqueness
    CONSTRAINT unique_commune_municipality_name
        UNIQUE (municipality_id, name)
);

CREATE INDEX idx_commune_municipality_id
    ON commune(municipality_id);

CREATE INDEX idx_commune_name
    ON commune(name);

CREATE INDEX idx_commune_deleted
    ON commune(deleted)
    WHERE deleted = FALSE;

CREATE INDEX idx_commune_created_by
    ON commune(created_by);

CREATE INDEX idx_commune_changed_by
    ON commune(changed_by);

COMMENT ON TABLE commune IS 'Commune Table';

COMMENT ON COLUMN commune.id
IS 'Automatically generated numeric ID (TSID)';

COMMENT ON COLUMN commune.municipality_id
IS 'Reference to the municipality';

COMMENT ON COLUMN commune.name
IS 'Commune name';

COMMENT ON COLUMN commune.alpha_code
IS 'Official commune code';

COMMENT ON COLUMN commune.deleted
IS 'Soft delete: TRUE = deleted, FALSE = active';

ALTER TABLE public.commune OWNER TO postgres;