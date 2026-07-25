BEGIN;

CREATE TABLE party (
    id BIGINT PRIMARY KEY,
    party_type INT NOT NULL DEFAULT 2,
    status INT NOT NULL DEFAULT 2,
    created_by BIGINT NOT NULL,
    changed_by BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted BOOLEAN NOT NULL DEFAULT FALSE
);

-- Índices PARTY
CREATE INDEX idx_party_party_type ON party(party_type);
CREATE INDEX idx_party_status ON party(status);
CREATE INDEX idx_party_created_by ON party(created_by);
CREATE INDEX idx_party_changed_by ON party(changed_by);

COMMENT ON COLUMN party.status IS '1=ACTIVE, 2=INACTIVE, 3=BLOCKED';

CREATE TABLE person (
    id BIGINT PRIMARY KEY,
    party_id BIGINT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    birth_date DATE,
    gender_id INT NOT NULL DEFAULT 3 CHECK (gender_id IN (1, 2, 3)),
    status INT NOT NULL DEFAULT 2 CHECK (status IN (1, 2, 3)),
    created_by BIGINT NOT NULL,
    changed_by BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted BOOLEAN NOT NULL DEFAULT FALSE,

     CONSTRAINT fk_person_party FOREIGN KEY (party_id) REFERENCES party(id),
     CONSTRAINT unique_person_party_name_birth UNIQUE (party_id, first_name, last_name, birth_date,gender_id),

);

-- indx PERSON
CREATE INDEX idx_person_party_id ON person(party_id);
CREATE INDEX idx_person_status ON person(status);
CREATE INDEX idx_person_gender_id ON person(gender_id);
CREATE INDEX idx_person_created_by ON person(created_by);
CREATE INDEX idx_person_changed_by ON person(changed_by);
CREATE INDEX idx_person_deleted ON person(deleted) WHERE deleted = FALSE;
CREATE INDEX idx_person_birth_date ON person(birth_date) WHERE birth_date IS NOT NULL;
CREATE INDEX idx_person_party_first_name ON person(party_id, first_name);

COMMENT ON TABLE person IS 'Table of individuals (HUMAN users)';
COMMENT ON COLUMN person.id IS 'Automatically generated numeric ID';
COMMENT ON COLUMN person.party_id IS 'Company to which the person belongs';
COMMENT ON COLUMN person.first_name IS 'First name (minimum 2 characters)';
COMMENT ON COLUMN person.last_name IS 'Last name (can be NULL)';
COMMENT ON COLUMN person.birth_date IS 'Date of birth';
COMMENT ON COLUMN person.gender_id IS '1=MALE, 2=FEMALE, 3=OTHER';
COMMENT ON COLUMN person.status IS '1=ACTIVE, 2=INACTIVE, 3=BLOCKED'; COMMENT ON COLUMN person.deleted IS 'Soft delete: TRUE = deleted, FALSE = active';

CREATE TABLE users (
    id BIGINT PRIMARY KEY,
    party_id BIGINT NULL,
    tenant_party_id BIGINT NOT NULL,
    access_role_id BIGINT NOT NULL,
    user_type INT NOT NULL DEFAULT 2 CHECK (user_type IN (1, 2)),
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    email_verified_at TIMESTAMPTZ,
    password_hash VARCHAR(255),
    mfa_enabled BOOLEAN DEFAULT FALSE,
    status INT NOT NULL DEFAULT 2 CHECK (status IN (1, 2, 3)),
    deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_by BIGINT NOT NULL,
    changed_by BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT fk_user_tenant_party FOREIGN KEY (tenant_party_id) REFERENCES party(id),
    CONSTRAINT unique_tenant_user_name UNIQUE (tenant_party_id, user_name),
    CONSTRAINT unique_tenant_email UNIQUE (tenant_party_id, email)
);

 -- Coment
 COMMENT ON COLUMN users.user_type IS '1=HUMAN, 2=SYSTEM';
 COMMENT ON COLUMN users.status IS '1=ACTIVE, 2=INACTIVE, 3=BLOCKED';
 COMMENT ON COLUMN users.deleted IS 'Soft delete';

 -- Performance index
 CREATE INDEX idx_users_party_id ON users(party_id) WHERE party_id IS NOT NULL;
 CREATE INDEX idx_users_tenant_party ON users(tenant_party_id),
 CREATE INDEX idx_users_access_role_id ON users(access_role_id);
 CREATE INDEX idx_users_user_type ON users(user_type);
 CREATE INDEX idx_users_status ON users(status);
 CREATE INDEX idx_users_deleted ON users(deleted) WHERE deleted = FALSE;
 CREATE INDEX idx_users_created_by ON users(created_by);
 CREATE INDEX idx_users_changed_by ON users(changed_by);
 CREATE INDEX idx_users_email ON users(email) WHERE email IS NOT NULL;

ALTER TABLE public.party OWNER TO postgres;
ALTER TABLE public.users OWNER TO postgres;
ALTER TABLE public.person OWNER TO postgres;

 -- insert for company -> berp
INSERT INTO party (
    id,
    party_type,
    status,
    created_by,
    changed_by,
    created_at,
    updated_at
) VALUES (
    1,
    2,
    1,
    0, -- temporário, será atualizado a seguir
    0, -- temporário, será atualizado a seguir
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- insert for company's user -> berp
INSERT INTO party (
    id,
    party_type,
    status,
    created_by,
    changed_by,
    created_at,
    updated_at
) VALUES (
    2,
    1,
    1,
    0, -- temporário, será atualizado a seguir
    0, -- temporário, será atualizado a seguir
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO users (
    id,
    party_id,
    tenant_party_id,
    access_role_id,
    user_type,
    user_name,
    email,
    email_verified_at,
    password_hash,
    status,
    created_by,
    changed_by,
    created_at,
    updated_at
) VALUES (
    1,
    2, -- party_id = user's berp
    1, -- tenant_party_id = empresa berp
    1, -- ACCESS_ROLE - > SECURITY_ADMIN
    1,  --> SYSTEM USER
    'security_admin',
    'securiy_admin@berp.co.ao',
    CURRENT_TIMESTAMP,
    '$2a$10$e1Fci4dViHIsjyzsyOqca.N8Z6l/KMT8Exx4P88qik3YUKjsl5AKm',
    1,
    0, -- temporário, será atualizado
    0, -- temporário, será atualizado
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);



UPDATE party SET created_by = 1, changed_by = 1 WHERE id = 1;
UPDATE users SET created_by = 1, changed_by = 1 WHERE id = 1;
UPDATE party SET created_by = 1, changed_by = 1 WHERE id = 2;

COMMIT;