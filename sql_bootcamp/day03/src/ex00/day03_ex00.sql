SELECT 
    pizza_name,
    price,
    pizzeria.name AS pizzeria_name,
    visit_date
FROM pizzeria
JOIN person_visits ON pizzeria.id = person_visits.pizzeria_id
JOIN menu ON menu.pizzeria_id = pizzeria.id
JOIN person ON person.id = person_visits.person_id
WHERE price BETWEEN 800 AND 1000 and person.name = 'Kate'
ORDER BY pizza_name, price, pizzeria_name;