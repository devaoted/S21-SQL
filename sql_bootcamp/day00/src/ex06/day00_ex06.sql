SELECT 
    (SELECT name FROM person WHERE person_id = id) AS NAME, 
    (SELECT name = 'Denis' FROM person WHERE person_id = id) AS CHECK_NAME
FROM person_order
WHERE (menu_id = '13' OR menu_id = '14' OR menu_id = '18') AND order_date = '2022.01.07'