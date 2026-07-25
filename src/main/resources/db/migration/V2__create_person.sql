-- Person shares PK with Party (id = party_id) — 1-to-1 relationship guaranteed by the
-- own structure, without needing extra UNIQUE. No audit/soft-delete
-- own: live in the line of the corresponding Party.
CREATE TABLE person (
    id          BIGINT PRIMARY KEY REFERENCES party (id) ON DELETE CASCADE,
    first_name  VARCHAR(150) NOT NULL,
    last_name   VARCHAR(150) NOT NULL,
    birth_date  DATE,
    gender_id   INT NOT NULL DEFAULT 3 CHECK (gender_id IN (1, 2, 3))
);

COMMENT ON COLUMN person.gender_id IS '1=MALE, 2=FEMALE, 3=OTHER';

CREATE INDEX idx_person_gender ON person (gender_id);
