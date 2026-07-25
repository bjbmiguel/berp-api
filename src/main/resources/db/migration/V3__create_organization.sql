-- Organization shares PK with Party. org_type distinguishes Company from Unit.
-- login_slug: only for org_type=1 (COMPANY) — public identifier decoupled from the id,
-- used in the login URL /{login_slug}/auth/login.
CREATE TABLE organization (
    id              BIGINT PRIMARY KEY REFERENCES party (id) ON DELETE CASCADE,
    org_type        INT NOT NULL,
    unit_type       INT NOT NULL DEFAULT 0,
    legal_name      VARCHAR(200) NOT NULL,
    login_slug      VARCHAR(100) UNIQUE,
    parent_unit_id  BIGINT REFERENCES organization (id),
    CONSTRAINT chk_org_type CHECK (org_type IN (1, 2)),
    CONSTRAINT chk_unit_type_matches_org_type CHECK (
        (org_type = 1 AND unit_type = 0)   -- COMPANY: unit_type does not apply
        OR (org_type = 2 AND unit_type <> 0)  -- UNIT: unit_type required
    ),
    CONSTRAINT chk_login_slug_only_company CHECK (
        (org_type = 1) OR (org_type = 2 AND login_slug IS NULL)
    )
);

COMMENT ON COLUMN organization.org_type IS '1=COMPANY, 2=UNIT';
COMMENT ON COLUMN organization.unit_type IS
'0=N/A (only for org_type=COMPANY), 1=HEAD_OFFICE, 2=BRANCH, 3=DEPARTMENT, '
'4=TEAM, 5=WAREHOUSE, 6=STORE, 7=GYM, 8=PHARMACY, 9=OFFICE, 10=LAB. '
'No CHECK to enumerate the values on purpose — list kept only in code '
'(Java enum), so as not to force a new migration every time a type is added.';

CREATE INDEX idx_organization_parent ON organization (parent_unit_id);
CREATE INDEX idx_organization_org_type ON organization (org_type);
CREATE INDEX idx_organization_unit_type ON organization (unit_type);
