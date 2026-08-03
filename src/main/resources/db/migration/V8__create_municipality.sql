CREATE TABLE municipality (
    -- Municipality data
    id BIGINT PRIMARY KEY,
    province_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    alpha_code VARCHAR(50) NULL,
    deleted BOOLEAN NOT NULL DEFAULT FALSE,

    -- Audit
    created_by BIGINT NOT NULL,
    changed_by BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT fk_municipality_province
        FOREIGN KEY (province_id) REFERENCES province(id),

    CONSTRAINT fk_municipality_created_by
        FOREIGN KEY (created_by) REFERENCES users(id),

    CONSTRAINT fk_municipality_changed_by
        FOREIGN KEY (changed_by) REFERENCES users(id),

    -- Uniqueness
    CONSTRAINT unique_municipality_province_name
        UNIQUE (province_id, name)
);

CREATE INDEX idx_municipality_province_id
    ON municipality(province_id);

CREATE INDEX idx_municipality_name
    ON municipality(name);

CREATE INDEX idx_municipality_deleted
    ON municipality(deleted)
    WHERE deleted = FALSE;

CREATE INDEX idx_municipality_created_by
    ON municipality(created_by);

CREATE INDEX idx_municipality_changed_by
    ON municipality(changed_by);

COMMENT ON TABLE municipality IS 'Municipality Table';

COMMENT ON COLUMN municipality.id
IS 'Automatically generated numeric ID (TSID)';

COMMENT ON COLUMN municipality.province_id
IS 'Reference to the province';

COMMENT ON COLUMN municipality.name
IS 'Municipality name';

COMMENT ON COLUMN municipality.alpha_code
IS 'Official municipality code';

COMMENT ON COLUMN municipality.deleted
IS 'Soft delete: TRUE = deleted, FALSE = active';

ALTER TABLE public.municipality OWNER TO postgres;