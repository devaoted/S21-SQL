CREATE OR REPLACE FUNCTION remove_sql_dml_triggers() 
RETURNS INTEGER
AS $$
DECLARE 
    trigger_row pg_trigger%ROWTYPE;
    count INTEGER := 0;
BEGIN
    FOR trigger_row IN
        SELECT * FROM pg_trigger
        WHERE tgconstraint = 0 AND
              tgdeferrable = FALSE AND
              tgnargs = 0 AND
              tgconstrrelid = 0 AND
              tginitdeferred = FALSE
    LOOP
        EXECUTE 'DROP TRIGGER ' || trigger_row.tgname || ' ON ' || trigger_row.tgrelid;
        count := count + 1;
    END LOOP;
    RETURN count;
END;
$$ 
LANGUAGE plpgsql;

-- та же ситуация, что и во втором задании
-- SELECT remove_sql_dml_triggers();