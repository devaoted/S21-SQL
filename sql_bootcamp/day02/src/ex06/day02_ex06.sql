SELECT pizza_name, pizzeria.name AS pizzeria_name
FROM menu
JOIN person_order ON person_order.menu_id = menu.id
JOIN pizzeria ON pizzeria.id = menu.pizzeria_id
WHERE person_id = 1 OR person_id = 4
ORDER BY pizza_name, pizzeria_name
