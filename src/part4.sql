-- 1
CREATE OR REPLACE PROCEDURE drop_tables_with_prefix(prefix text) AS $$
DECLARE
    table_name text;
BEGIN
    FOR table_name IN
        SELECT information_schema.tables.table_name
        FROM information_schema.tables
        WHERE table_schema = current_schema() 
            AND information_schema.tables.table_name LIKE prefix || '%'
    LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(table_name) || ' CASCADE';
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- 2
CREATE OR REPLACE PROCEDURE get_scalar_functions(
    OUT function_count integer
) AS $$
DECLARE
    function_details text := ' ';
    frec record;
BEGIN
    function_count := 0;
    
    FOR frec IN
        SELECT 
            routine_name AS name, 
            string_agg(parameter_name || ' ' || pr.data_type, ', ') AS parameters
        FROM information_schema.parameters pr
        JOIN information_schema.routines rt 
            ON rt.specific_name = pr.specific_name
        JOIN pg_proc pg 
            ON pg.proname = rt.routine_name
        WHERE 
            pr.specific_schema = current_schema() -- пространство имен - текущая схема
            AND pr.parameter_mode = 'IN' -- рассматриваем только функции с входными аргументами
            AND rt.routine_type = 'FUNCTION' -- функция, а не процедура
            AND pg.prorettype::regtype IN -- return type скалярный
            ('boolean', 'integer', 'bigint', 'real', 'numeric', 'varchar', 'text', 'date', 'time', 'timestamp', 'uuid')
        GROUP BY routine_name
    LOOP
        function_details := function_details || frec.name || '(' || frec.parameters || ')' || CHR(10);
        function_count := function_count + 1;
    END LOOP;
    RAISE NOTICE 'Найдено % скалярных функций:', function_count;
    RAISE NOTICE '%', function_details;
END;
$$ LANGUAGE plpgsql;

-- 3 
CREATE OR REPLACE PROCEDURE destroy_dml_triggers(
    OUT trigger_count integer
) AS $$
DECLARE
    trigger_rec record;
BEGIN
    trigger_count := 0;

    FOR trigger_rec IN (
        SELECT tgname, relname
        FROM pg_trigger
        JOIN pg_class ON pg_trigger.tgrelid = pg_class.oid
        WHERE tgconstraint = 0
    )
    LOOP
        EXECUTE 'DROP TRIGGER IF EXISTS ' || quote_ident(trigger_rec.tgname) || ' ON ' || quote_ident(trigger_rec.relname);
        trigger_count := trigger_count + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- 4
CREATE OR REPLACE PROCEDURE get_object_types_with_string(
    IN search_string text
)
AS $$
DECLARE
    object_count integer := 0;
    object_details text := '';
    object_rec record;
BEGIN
    FOR object_rec IN (
        SELECT p.proname AS object_name, d.description AS object_description
        FROM pg_proc p
        LEFT JOIN pg_description d ON p.oid = d.objoid
        WHERE (p.proname ILIKE '%' || search_string || '%' 
            OR d.description ILIKE '%' || search_string || '%')
            AND p.prokind IN ('f', 'p') -- Только функции и процедуры
    )
    LOOP
        object_count := object_count + 1;
        object_details := object_details || object_rec.object_name || ' - ' || 
            COALESCE(object_rec.object_description, 'None') || CHR(10);
    END LOOP;

    RAISE NOTICE 'Найдено % объектов:', object_count;
    RAISE NOTICE 'Описания:%', object_details;
END;
$$ LANGUAGE plpgsql;

-- -- 1

-- CREATE OR REPLACE PROCEDURE public.drop_tables_by_prefix(
--     prefix_to_drop text
-- ) LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     EXECUTE format(
--         'DROP TABLE IF EXISTS %s CASCADE',
--         (SELECT string_agg(format('%I.%I', table_schema, table_name), ', ')
--          FROM information_schema.tables
--          WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
--            AND table_name LIKE prefix_to_drop || '%')
--     );
-- END;
-- $$;

-- -- 2
-- CREATE OR REPLACE FUNCTION show_scalar_functions(out name TEXT, out params TEXT)
-- RETURNS SETOF RECORD AS $$
-- DECLARE
--   func_oid oid;
-- BEGIN
--   FOR func_oid IN 
--     SELECT p.oid
--     FROM pg_proc p 
--     WHERE p.pronamespace = 2200::oid
--       AND pg_proc_is_visible(p.oid) = true 
--       AND pg_function_is_scalar(p.oid) = true
--       AND pg_get_function_arguments(p.oid) IS NOT NULL
--   LOOP
--     SELECT p.proname, pg_get_function_arguments(func_oid) INTO name, params FROM pg_proc p WHERE p.oid = func_oid;
--     RETURN NEXT;
--   END LOOP;
--   RETURN;
-- END $$ LANGUAGE plpgsql;

-- -- 3 
-- CREATE OR REPLACE FUNCTION remove_sql_dml_triggers() 
-- RETURNS INTEGER
-- AS $$
-- DECLARE 
--     trigger_row pg_trigger%ROWTYPE;
--     count INTEGER := 0;
-- BEGIN
--     FOR trigger_row IN
--         SELECT * FROM pg_trigger
--         WHERE tgconstraint = 0 AND
--               tgdeferrable = FALSE AND
--               tgnargs = 0 AND
--               tgconstrrelid = 0 AND
--               tginitdeferred = FALSE
--     LOOP
--         EXECUTE 'DROP TRIGGER ' || trigger_row.tgname || ' ON ' || trigger_row.tgrelid;
--         count := count + 1;
--     END LOOP;
--     RETURN count;
-- END;
-- $$ 
-- LANGUAGE plpgsql;

-- -- 4
-- CREATE OR REPLACE PROCEDURE search_objects(p_str text)
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     SELECT pg_proc.proname, pg_proc.prosrc, 'PROCEDURE' AS obj_type
--     FROM pg_proc
--     WHERE pg_proc.prosrc LIKE '%' || p_str || '%'
--     UNION ALL
--     SELECT pg_proc.proname, pg_proc.prosrc, 'FUNCTION' AS obj_type
--     FROM pg_proc
--     WHERE pg_proc.prosrc LIKE '%' || p_str || '%' AND pg_proc.prorettype != 'pg_catalog.void'::regtype
--     ORDER BY 1, 3;
-- END;
-- $$;