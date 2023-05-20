CREATE UNIQUE INDEX idx_menu_unique ON menu(pizzeria_id, pizza_name);

SET enable_seqscan=OFF;
EXPLAIN ANALYZE 
SELECT m.pizza_name, pi.name 
FROM menu m
JOIN pizzeria pi ON m.pizzeria_id = pi.id;
SET enable_seqscan=ON;


-- DROP INDEX idx_menu_unique;