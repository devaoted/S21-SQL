CREATE OR REPLACE FUNCTION fnc_fibonacci(pstop integer default 10)
    RETURNS TABLE(fibonumbers integer) AS $$
    BEGIN
        RETURN QUERY (
            WITH RECURSIVE fib(n1, n2) AS (
                SELECT 0,1
                UNION ALL
                SELECT t.n2 AS n1,
                       t.n1 + t.n2 AS n2
                FROM fib t
                WHERE n2 < pstop
                )
                SELECT n2 FROM fib t
                LIMIT (SELECT COUNT(n2) - 1 FROM fib)
        );
    END;
$$
LANGUAGE 'plpgsql';

-- select * from fnc_fibonacci(100);
-- select * from fnc_fibonacci();