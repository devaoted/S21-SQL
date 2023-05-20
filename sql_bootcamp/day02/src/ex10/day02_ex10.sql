SELECT 
    one.name AS person_name1,
    two.name AS person_name2,
    one.address AS common_address
FROM 
    (SELECT id, name, address FROM person) AS one
CROSS JOIN
    (SELECT id, name, address FROM person) AS two
WHERE one.name != two.name AND one.address = two.address AND one.id > two.id