CREATE UNIQUE INDEX idx_person_discounts_unique 
ON person_discounts(person_id, pizzeria_id);
SET enable_seqscan=OFF;

EXPLAIN ANALYZE
SELECT pizzeria_id, person_id
FROM person_discounts;

SET enable_seqscan=ON;

-- DROP INDEX idx_person_discounts_unique;