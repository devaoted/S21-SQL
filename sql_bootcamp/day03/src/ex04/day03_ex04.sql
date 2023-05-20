WITH 
women_orders AS (
    SELECT p.name AS pizzeria_name FROM pizzeria AS p
    JOIN menu ON menu.pizzeria_id = p.id
    JOIN person_order AS po ON po.menu_id = menu.id
    JOIN person ON person.id = po.person_id
    WHERE person.gender = 'female'),
men_orders AS (
    SELECT p.name AS pizzeria_name FROM pizzeria AS p
    JOIN menu ON menu.pizzeria_id = p.id
    JOIN person_order AS po ON po.menu_id = menu.id
    JOIN person ON person.id = po.person_id
    WHERE person.gender = 'male'),
women_only AS (
    SELECT * FROM women_orders
    EXCEPT
    SELECT * FROM men_orders
),
men_only AS (
    SELECT * FROM men_orders
    EXCEPT
    SELECT * FROM women_orders
)

SELECT * FROM women_only
UNION
SELECT * FROM men_only
ORDER BY pizzeria_name;