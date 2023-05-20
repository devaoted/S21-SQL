SELECT person.id AS person_id, person.name AS person_name, 
       person.age, person.gender, person.address,
       pizzeria.id AS pizzeria_id, pizzeria.name AS pizzeria_name, pizzeria.rating
FROM person
CROSS JOIN pizzeria
ORDER BY person_id, pizzeria_id