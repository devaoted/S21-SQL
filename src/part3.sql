-- 1
CREATE OR REPLACE FUNCTION get_transferred_points()
RETURNS TABLE (peer1 text, peer2 text, points_amount integer) AS $$
BEGIN
    RETURN QUERY
    SELECT t1."Ник пира 1", t1."Ник пира 2", t1."Количество переданных пир поинтов" - COALESCE(t2."Количество переданных пир поинтов", 0)
    FROM transferred_points t1
    LEFT JOIN transferred_points t2 ON t1.checking_peer = t2.checked_peer AND t1. = t2."Ник пира 1"
    WHERE t1."Количество переданных пир поинтов" <> 0;

    RETURN;
END;
$$ LANGUAGE plpgsql;