CREATE INDEX idx_person_order_order_date ON person_order(person_id, menu_id)
WHERE order_date = '2022-01-01';

SET enable_seqscan=OFF;
EXPLAIN ANALYZE 
SELECT po.person_id FROM person p
JOIN person_order po ON po.person_id = p.id
WHERE po.order_date = '2022-01-01';
SET enable_seqscan=ON;

-- DROP INDEX idx_person_order_order_date;