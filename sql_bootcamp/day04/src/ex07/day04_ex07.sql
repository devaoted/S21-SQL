INSERT INTO person_visits VALUES (
    (SELECT MAX(id) + 1 FROM person_visits),
    (SELECT id FROM person WHERE name = 'Dmitriy'),
    (SELECT MAX(pz.id) FROM pizzeria AS pz
        JOIN menu m ON pz.id = m.pizzeria_id
        WHERE m.price < 800),
    '2022-01-08'
);

REFRESH MATERIALIZED VIEW mv_dmitriy_visits_and_eats;