CREATE SEQUENCE seq_person_discounts AS bigint START 1 INCREMENT 1;

SELECT SETVAL('seq_person_discounts', (SELECT MAX(id) FROM person_discounts));

ALTER TABLE person_discounts ALTER COLUMN id SET DEFAULT (NEXTVAL('seq_person_discounts'));
-- DROP SEQUENCE seq_person_discounts;