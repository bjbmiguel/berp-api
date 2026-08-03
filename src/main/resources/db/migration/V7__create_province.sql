CREATE TABLE province (
    -- Province data
    id BIGINT PRIMARY KEY,
    country_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    alpha_code VARCHAR(50)  NULL,
    deleted BOOLEAN NOT NULL DEFAULT FALSE,

    -- Auditoria (FK para users)
    created_by BIGINT NOT NULL,
    changed_by BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT fk_province_country FOREIGN KEY (country_id) REFERENCES country(id),
    CONSTRAINT fk_province_created_by FOREIGN KEY (created_by) REFERENCES users(id),
    CONSTRAINT fk_province_changed_by FOREIGN KEY (changed_by) REFERENCES users(id),

    -- Unicidade
    CONSTRAINT unique_province_country_name UNIQUE (country_id, name)
);


CREATE INDEX idx_province_country_id ON province(country_id);
CREATE INDEX idx_province_name ON province(name);
CREATE INDEX idx_province_deleted ON province(deleted) WHERE deleted = FALSE;
CREATE INDEX idx_province_created_by ON province(created_by);
CREATE INDEX idx_province_changed_by ON province(changed_by);

COMMENT ON TABLE province IS 'Province/State Table';
COMMENT ON COLUMN province.id IS 'Automatically generated numeric ID (TSID)';
COMMENT ON COLUMN province.country_id IS 'Reference to the country (ID)';
COMMENT ON COLUMN province.name IS 'Province/State name';
COMMENT ON COLUMN province.deleted IS 'Soft delete: TRUE = deleted, FALSE = active';

ALTER TABLE public.province OWNER TO postgres;