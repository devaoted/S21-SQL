INSERT INTO person_order
SELECT 
    p.id + (SELECT MAX(id) FROM person_order),
    p.id,
    (SELECT id FROM menu
    WHERE pizza_name = 'greek pizza'),
    '2022-02-25'
FROM person p;