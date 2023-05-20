CREATE VIEW v_persons_female AS
    SELECT name FROM person
    WHERE gender = 'female'
    ORDER BY name;

CREATE VIEW v_persons_male AS
    SELECT name FROM person
    WHERE gender = 'male'
    ORDER BY name;
