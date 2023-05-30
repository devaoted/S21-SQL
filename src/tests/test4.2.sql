CREATE OR REPLACE FUNCTION sum_integers(a INTEGER, b INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN a + b;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calculate_average(a FLOAT, b FLOAT, c FLOAT)
RETURNS FLOAT AS $$
BEGIN
    RETURN (a + b + c) / 3.0;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION concatenate_strings(a TEXT, b TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN a || b;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION record_func(a TEXT, b TEXT)
RETURNS table(peer text) AS $$
BEGIN
    RETURN query
    select nickname from peers;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION number_of_function() RETURNS int AS $$
DECLARE
    number_of_functions int;
BEGIN
    CALL get_scalar_functions(number_of_functions);
    RETURN number_of_functions;
END;
$$ LANGUAGE plpgsql;

SELECT number_of_function() AS num;