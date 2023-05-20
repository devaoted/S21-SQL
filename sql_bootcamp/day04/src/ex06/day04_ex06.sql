CREATE MATERIALIZED VIEW mv_dmitriy_visits_and_eats AS
SELECT pizzeria.name AS pizzeria_name FROM person_visits
JOIN person ON person_visits.person_id = person.id
JOIN pizzeria ON pizzeria.id = person_visits.pizzeria_id
JOIN menu ON menu.pizzeria_id = pizzeria.id
WHERE visit_date = '2022-01-08' AND price < 800
ORDER BY pizzeria_name;