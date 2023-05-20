WITH cte AS (SELECT po.person_id as p_id, m.pizzeria_id as pi_id, 
    row_number() OVER(PARTITION BY po.person_id, m.pizzeria_id) AS test
    FROM person_order po
    JOIN menu m ON po.menu_id = m.id)


INSERT INTO person_discounts(person_id, pizzeria_id, discount)
(SELECT p_id, pi_id, case 
    when count(test) = 1 then 10.5
    when count(test) = 2 then 22
    else 33
    end AS discount
FROM cte GROUP BY p_id, pi_id);


