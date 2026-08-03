CREATE TABLE country (
    -- Country data
    id BIGINT PRIMARY KEY,
    code CHAR(2) NOT NULL,
    name VARCHAR(100) ,
    alpha_3 CHAR(3),           -- BRA, USA, AGO, PRT
    telephone_code VARCHAR(50), -- +244, +55, +1
    deleted BOOLEAN NOT NULL DEFAULT FALSE,

    -- Auditoria (FK para users)
    created_by BIGINT NOT NULL,
    changed_by BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
      CONSTRAINT fk_country_created_by FOREIGN KEY (created_by) REFERENCES users(id),
      CONSTRAINT fk_country_changed_by FOREIGN KEY (changed_by) REFERENCES users(id),
      CONSTRAINT chk_country_code CHECK (code ~ '^[A-Z]{2}$'),


    -- Unicidade
     CONSTRAINT unique_country_code UNIQUE (code),
     CONSTRAINT unique_country_name UNIQUE (name),
     CONSTRAINT unique_country_alpha_3 UNIQUE (alpha_3)
);

-- Index
CREATE INDEX idx_country_code ON country(code);
CREATE INDEX idx_country_name ON country(name);
CREATE INDEX idx_country_deleted ON country(deleted) WHERE deleted = FALSE;
CREATE INDEX idx_country_created_by ON country(created_by);
CREATE INDEX idx_country_changed_by ON country(changed_by);

-- Coment
COMMENT ON TABLE country IS 'Country Table';
COMMENT ON COLUMN country.id IS 'Automatically generated numeric ID';
COMMENT ON COLUMN country.code IS 'ISO 3166-1 alpha-2 code (BR, US, AO)';
COMMENT ON COLUMN country.name IS 'Country name in English';
COMMENT ON COLUMN country.alpha_3 IS 'ISO 3166-1 alpha-3 code (BRA, USA, AGO)';
COMMENT ON COLUMN country.telephone_code IS 'International telephone code';
COMMENT ON COLUMN country.deleted IS 'Soft delete: TRUE = deleted, FALSE = active';

ALTER TABLE public.country OWNER TO postgres;