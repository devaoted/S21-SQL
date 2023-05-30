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