(SELECT
    MIN(name) AS name,
    COUNT(po.id) AS count,
    'order' AS action_type
FROM person_order po
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
GROUP BY pz.id
ORDER BY 2 DESC
LIMIT 3)
UNION ALL
(SELECT
    MIN(name) AS name,
    COUNT(pv.id) AS count,
    'visit' AS action_type
FROM person_visits pv
JOIN pizzeria pz ON pv.pizzeria_id = pz.id
GROUP BY pz.id
ORDER BY 2 DESC
LIMIT 3);