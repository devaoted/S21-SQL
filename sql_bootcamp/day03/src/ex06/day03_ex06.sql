WITH data(id1, id2, name1, name2) AS (
SELECT
    one.id,
    two.id,
    one.name,
    two.name
FROM
    (SELECT id, name FROM pizzeria) AS one
CROSS JOIN
    (SELECT id, name FROM pizzeria) AS two
WHERE one.id > two.id)


SELECT 
    m1.pizza_name,
    name1,
    name2,
    m1.price
FROM data
JOIN menu AS m1 ON m1.pizzeria_id = id1
JOIN menu AS m2 ON m2.pizzeria_id = id2
WHERE m1.price = m2.price AND m1.pizza_name = m2.pizza_name
ORDER BY m1.pizza_name;

-- SELECT
--     m1.pizza_name,
--     pi1.name AS pizzeria_name_1,
--     pi2.name AS pizzeria_name_2,
--     m1.price
-- FROM menu AS m1
-- JOIN (SELECT pizzeria_id, pizza_name, price FROM menu) AS m2
--         ON m2.price = m1.price AND m1.pizza_name = m2.pizza_name
--         AND m1.pizzeria_id > m2.pizzeria_id
-- JOIN pizzeria AS pi1 ON pi1.id = m1.pizzeria_id
-- JOIN pizzeria AS pi2 ON pi2.id = m2.pizzeria_id
-- ORDER BY pizza_name