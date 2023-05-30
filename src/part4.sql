-- 1

CREATE OR REPLACE PROCEDURE public.drop_tables_by_prefix(
    prefix_to_drop text
) LANGUAGE plpgsql
AS $$
BEGIN
    EXECUTE format(
        'DROP TABLE IF EXISTS %s CASCADE',
        (SELECT string_agg(format('%I.%I', table_schema, table_name), ', ')
         FROM information_schema.tables
         WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
           AND table_name LIKE prefix_to_drop || '%')
    );
END;
$$;
-- CALL public.drop_tables_by_prefix('tablename');

-- 2
CREATE OR REPLACE FUNCTION show_scalar_functions(out name TEXT, out params TEXT)
RETURNS SETOF RECORD AS $$
DECLARE
  func_oid oid;
BEGIN
  FOR func_oid IN 
    SELECT p.oid
    FROM pg_proc p 
    WHERE p.pronamespace = 2200::oid
      AND pg_proc_is_visible(p.oid) = true 
      AND pg_function_is_scalar(p.oid) = true
      AND pg_get_function_arguments(p.oid) IS NOT NULL
  LOOP
    SELECT p.proname, pg_get_function_arguments(func_oid) INTO name, params FROM pg_proc p WHERE p.oid = func_oid;
    RETURN NEXT;
  END LOOP;
  RETURN;
END $$ LANGUAGE plpgsql;


-- есть шанс, что оно работает, но сперва надо создать функции
-- SELECT * FROM show_scalar_functions();


-- 3 
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

-- 4
CREATE OR REPLACE PROCEDURE search_objects(p_str text)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT pg_proc.proname, pg_proc.prosrc, 'PROCEDURE' AS obj_type
    FROM pg_proc
    WHERE pg_proc.prosrc LIKE '%' || p_str || '%'
    UNION ALL
    SELECT pg_proc.proname, pg_proc.prosrc, 'FUNCTION' AS obj_type
    FROM pg_proc
    WHERE pg_proc.prosrc LIKE '%' || p_str || '%' AND pg_proc.prorettype != 'pg_catalog.void'::regtype
    ORDER BY 1, 3;
END;
$$;

-- та же история
-- CALL search_objects('SELECT');