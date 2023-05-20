WITH cte_pv as (SELECT pi.name, count(pv.pizzeria_id), 'visit' AS action_type
FROM person_visits pv 
JOIN pizzeria pi ON pv.pizzeria_id = pi.id
GROUP BY pi.name),

cte_po as (SELECT pi.name, count(m.pizzeria_id), 'order' as action_type
FROM person_order po 
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria pi ON m.pizzeria_id = pi.id
GROUP BY pi.name)

select cte_pv.name, cte_pv.count + cte_po.count AS total_count
FROM cte_pv
LEFT JOIN cte_po ON cte_pv.name = cte_po.name

ORDER BY 2 DESC, 1 ASC;