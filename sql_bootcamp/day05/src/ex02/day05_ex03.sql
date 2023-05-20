CREATE INDEX idx_person_name ON person(UPPER(name));

SET enable_seqscan=OFF;
EXPLAIN ANALYZE
SELECT name
FROM person 
WHERE UPPER(name) = 'Denis';
SET enable_seqscan=ON;

-- DROP INDEX idx_person_name;