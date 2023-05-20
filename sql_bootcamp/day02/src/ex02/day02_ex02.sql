SELECT
    (CASE WHEN person.name is NULL THEN '-' ELSE person.name END) AS person_name,
    visits.visit_date,
    (CASE WHEN pizzeria.name is NULL THEN '-' ELSE pizzeria.name END) AS pizzeria_name
FROM 
    person
FULL JOIN 
    (SELECT visit_date, person_id, pizzeria_id FROM person_visits
    WHERE visit_date BETWEEN '2022-01-01' AND '2022-01-03') AS visits
ON visits.person_id = person.id
FULL JOIN
    pizzeria 
ON pizzeria.id = visits.pizzeria_id
ORDER BY person_name, visit_date, pizzeria_name
