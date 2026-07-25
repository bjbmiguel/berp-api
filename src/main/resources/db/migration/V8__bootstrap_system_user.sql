-- 1) Party (party_type=PERSON) + Person que representam a identidade do
--    security_admin. Placeholder claramente identificado como tal
--    (first_name='BERP'), nao pessoa real nem nome fictício disfarcado.
--    Node PARTY=1 (person partilha PK com party).
INSERT INTO party (id, party_type, status, created_by, changed_by)
VALUES (868870724129920997, 1, 1, 868870724138315526, 868870724138315526);

INSERT INTO person (id, first_name, last_name, birth_date, gender_id)
VALUES (868870724129920997, 'BERP', 'Administrador', NULL, 3);



-- 3) O User HUMAN de bootstrap propriamente dito. Node USERS=2.
-- E HUMAN (nao SYSTEM) porque e usado por uma pessoa real via GUI para gerir
-- a seguranca da plataforma. Serve tambem como created_by/changed_by de todos
-- os seeds acima (bootstrap auto-referente).
--
-- ATENCAO: a password_hash abaixo e um placeholder de exemplo (bcrypt). TROCAR
-- antes de qualquer ambiente real — gerar um hash novo para uma password forte propria.
INSERT INTO users (
    id, party_id, tenant_party_id, access_role_id, managed_by, user_type,
    user_name, email, email_verified_at, password_hash, description, status,
    created_by, changed_by
) VALUES (
    868870724138315526,              -- id (SystemIds.SYSTEM_USER_ID)
    868870724129920997,              -- party_id: Person placeholder (acima)
    868870724121533426,              -- tenant_party_id: Organization da plataforma (V1_6)
    868870724146713946,              -- access_role_id: SECURITY_ADMIN
    NULL,                             -- managed_by: nao aplicavel (e HUMAN, nao SYSTEM)
    1,                                -- user_type: HUMAN
    'super_admin',
    'super_admin@berp.co.ao',
    CURRENT_TIMESTAMP,
    '$2a$10$e1Fci4dViHIsjyzsyOqca.N8Z6l/KMT8Exx4P88qik3YUKjsl5AKm',
    'BERP platform bootstrap account — restricted to startup/emergency use.',
    2,                                -- status: ACTIVE
    868870724138315526,              -- created_by: auto-referente (bootstrap)
    868870724138315526               -- changed_by: auto-referente (bootstrap)
);
