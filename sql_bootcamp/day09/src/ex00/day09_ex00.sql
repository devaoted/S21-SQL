CREATE TABLE person_audit(
    created timestamptz not null default current_timestamp,
    type_event char(1) not null default 'I',
    row_id bigint not null,
    name varchar,
    age integer,
    gender varchar,
    address varchar,
    CONSTRAINT ch_type_event CHECK (type_event IN ('I', 'D', 'U'))
);

CREATE FUNCTION fnc_trg_person_insert_audit()
    RETURNS TRIGGER AS 
    $$
    BEGIN
        INSERT INTO person_audit(created, type_event, row_id, name, age, gender, address)
            VALUES (current_timestamp,
                    'I',
                    NEW.id,
                    NEW.name,
                    NEW.age,
                    NEW.gender,
                    NEW.address);
        RETURN NEW;
    END;
    $$
LANGUAGE 'plpgsql';

CREATE TRIGGER trg_person_insert_audit
    AFTER INSERT
    ON person
    FOR EACH ROW
    EXECUTE PROCEDURE fnc_trg_person_insert_audit();

INSERT INTO person(id, name, age, gender, address)
VALUES (10,'Damir', 22, 'male', 'Irkutsk');

-- select * from person;
-- SELECT * FROM person_audit;