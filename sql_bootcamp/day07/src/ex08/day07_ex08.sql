SELECT p.address, pi.name, count(p.name) AS count_of_orders 
FROM person_order po
JOIN person p ON po.person_id = p.id
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria pi ON pi.id = m.pizzeria_id
GROUP BY p.address, pi.name
ORDER BY 1, 2;