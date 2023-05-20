CREATE OR REPLACE FUNCTION func_minimum(VARIADIC arr NUMERIC[])
    RETURNS numeric AS $$
    DECLARE
        val numeric := arr[1];
        i numeric := 0;
    BEGIN
        FOREACH i IN ARRAY arr LOOP
            IF i < val THEN
                val := i;
            END IF;
        END LOOP;
        RETURN val;
    END;
$$
LANGUAGE 'plpgsql';

-- SELECT func_minimum(VARIADIC arr => ARRAY[10.0, -1.0, 5.0, 4.4]);