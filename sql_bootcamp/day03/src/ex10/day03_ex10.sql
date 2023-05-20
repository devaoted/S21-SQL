INSERT INTO person_order
    VALUES (
        (SELECT MAX(pv.id) + 1 FROM person_order AS pv),
        (SELECT person.id FROM person
        WHERE person.name = 'Denis'),
        (SELECT id FROM menu
        WHERE pizza_name = 'sicilian pizza'),
        '2022-02-24');

INSERT INTO person_order
    VALUES (
        (SELECT MAX(pv.id) + 1 FROM person_order AS pv),
        (SELECT person.id FROM person
        WHERE person.name = 'Irina'),
        (SELECT id FROM menu
        WHERE pizza_name = 'sicilian pizza'),
        '2022-02-24');
    