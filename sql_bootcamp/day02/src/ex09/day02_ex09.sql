WITH female_orders(person, menu_name) AS (
    SELECT person.name, menu.pizza_name FROM person
    JOIN person_order ON person.id = person_order.person_id
    JOIN menu ON menu.id = person_order.menu_id
    WHERE person.gender = 'female'
)

SELECT pep.person
FROM 
    (SELECT person, menu_name FROM female_orders
    WHERE menu_name = 'pepperoni pizza') AS pep 
JOIN 
   (SELECT person, menu_name FROM female_orders
    WHERE menu_name = 'cheese pizza') AS cheese
ON pep.person = cheese.person
ORDER BY pep.person