-- Special Party/Organization representing BERP itself (the platform, not a client).
-- IDs are real TSIDs (today's timestamp + embedded table node — node PARTY=1), not sequential numbers like 1/2/3.
-- created_by/changed_by reference the system User (V1_7) — works without FOREIGN KEY in these columns (see V1_1), avoiding circular dependency.
INSERT INTO party (id, party_type, status, created_by, changed_by,created_at,updated_at)
VALUES (868870724121533426, 2, 1, 868870724138315526, 868870724138315526,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);

INSERT INTO organization (id, org_type, unit_type, legal_name, login_slug, parent_unit_id)
VALUES (868870724121533426, 1, 0, 'BERP Platform', 'e523315d-5799-42e3-9ffb-6f96a91bbe53', NULL);