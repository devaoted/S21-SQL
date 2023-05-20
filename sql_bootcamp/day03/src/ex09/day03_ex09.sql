INSERT INTO person_visits
    VALUES (
        (SELECT MAX(pv.id) + 1 FROM person_visits AS pv),
        (SELECT pz.id FROM pizzeria AS pz
        WHERE pz.name = 'Dominos'),
        (SELECT person.id FROM person
        WHERE person.name = 'Denis'),
        '2022-02-24');

INSERT INTO person_visits
    VALUES (
        (SELECT MAX(pv.id) + 1 FROM person_visits AS pv),
        (SELECT pz.id FROM pizzeria AS pz
        WHERE pz.name = 'Dominos'),
        (SELECT person.id FROM person
        WHERE person.name = 'Irina'),
        '2022-02-24');