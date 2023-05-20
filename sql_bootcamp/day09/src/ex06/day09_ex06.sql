CREATE OR REPLACE FUNCTION fnc_person_visits_and_eats_on_date(pperson varchar default 'Dmitriy',
                                                              pprice numeric default 500,
                                                              pdate date default DATE('2022-01-08'))
    RETURNS TABLE(pizzerias varchar) AS $$
    BEGIN
        RETURN QUERY
        (SELECT pz.name AS pizzerias
        FROM person_visits pv
            JOIN person p ON pv.person_id = p.id
            JOIN pizzeria pz ON pz.id = pv.pizzeria_id
            JOIN menu m ON m.pizzeria_id = pz.id
        WHERE p.name = pperson AND
              m.price < pprice AND
              pv.visit_date = pdate
        GROUP BY pz.name);
    END;
$$
LANGUAGE 'plpgsql';

-- SELECT * FROM fnc_person_visits_and_eats_on_date(pprice := 800);

-- SELECT * FROM fnc_person_visits_and_eats_on_date(pperson := 'Anna',
--                                         pprice := 1300,
                                        pdate := '2022-01-01');