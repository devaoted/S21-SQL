SELECT pizzeria.name FROM pizzeria
JOIN person_visits AS pv ON pv.pizzeria_id = pizzeria.id
JOIN person ON pv.person_id = person.id
WHERE person.name = 'Andrey'

EXCEPT

SELECT pizzeria.name FROM pizzeria
JOIN menu ON menu.pizzeria_id = pizzeria.id
JOIN person_order ON person_order.menu_id = menu.id
JOIN person ON person_order.person_id = person.id
WHERE person.name = 'Andrey';

