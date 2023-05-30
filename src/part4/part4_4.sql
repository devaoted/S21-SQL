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