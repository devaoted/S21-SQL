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

CALL public.drop_tables_by_prefix('tablename');