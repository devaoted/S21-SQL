SELECT p.name, m.pizza_name, m.price, 
(m.price - m.price * 0.01 * (pd.discount)) as discount_price, 
pi.name as pizzeria_name
FROM person_discounts pd
JOIN person p ON pd.person_id = p.id
JOIN pizzeria pi ON pi.id = pd.pizzeria_id
JOIN menu m ON m.pizzeria_id = pd.pizzeria_id
ORDER BY 1, 2;