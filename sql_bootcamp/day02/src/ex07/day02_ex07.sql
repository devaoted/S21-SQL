SELECT pizzeria.name AS pizzeria_name
FROM person_visits
JOIN menu ON menu.pizzeria_id = person_visits.pizzeria_id
JOIN pizzeria ON pizzeria.id = person_visits.pizzeria_id
WHERE person_id = 9 AND price < 800 AND visit_date = '2022-01-08'
ORDER BY pizzeria.name