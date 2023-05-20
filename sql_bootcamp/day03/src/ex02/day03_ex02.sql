SELECT
    pizza_name,
    price,
    pizzeria.name
FROM menu
JOIN 
    pizzeria ON pizzeria.id = menu.pizzeria_id
JOIN (
    SELECT menu.id
    FROM menu
    EXCEPT
    SELECT menu_id
    FROM person_order) AS ex01 ON ex01.id = menu.id
ORDER BY pizza_name, price;