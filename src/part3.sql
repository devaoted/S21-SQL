-- 1
CREATE OR REPLACE FUNCTION get_transferred_points()
RETURNS TABLE (Peer1 text, Peer2 text, PointsAmount int) AS $$
BEGIN
    RETURN QUERY
    SELECT tp1.checking_peer AS peer1, tp1.checked_peer AS peer2, tp1.points_amount - COALESCE(tp2.points_amount, 0) AS number
    FROM transferred_points tp1
    LEFT JOIN transferred_points tp2 ON tp1.checked_peer = tp2.checking_peer AND tp1.checking_peer = tp2.checked_peer
     WHERE tp1.checking_peer < tp1.checked_peer
        OR (tp1.checking_peer > tp1.checked_peer AND tp2.checked_peer is NULL);
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- 2 Тут можно добавить проверку WHERE checks_status(check_id) = 'success'
-- но так как ch_xp проверяет это при вставке, то нет необходимости

CREATE OR REPLACE FUNCTION get_xp()
RETURNS TABLE (Peer text, Task text, XP float) AS $$
BEGIN
    RETURN QUERY
    SELECT checks.peer, checks.task, xp_amount FROM xp JOIN checks ON check_id = checks.id;
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- 3 ch_time_tracking проверяет при вставке что первая за день запись state = 1
-- и state (со значениями 1 или 2) каждой последующей за день записи не равняется предыдущей

CREATE OR REPLACE FUNCTION get_time_tracking_no_leave (
    p_date date
)
RETURNS TABLE (Peer text) AS $$
BEGIN
    RETURN QUERY
    WITH peer_count AS (
        SELECT tt.peer, COUNT(*) FROM time_tracking tt WHERE date = p_date GROUP BY tt.peer
    )
    SELECT pc.peer FROM peer_count pc WHERE count > 2;
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- 4

CREATE OR REPLACE FUNCTION get_transferred_points_change()
RETURNS TABLE (Peer text, PointsChange int) AS $$
BEGIN
    RETURN QUERY
    SELECT tp.checking_peer, CAST(SUM(tp.points_amount - COALESCE(tp2.points_amount, 0)) AS int)
    FROM transferred_points tp
    LEFT JOIN transferred_points tp2 ON tp.checked_peer = tp2.checking_peer
        AND tp.checking_peer = tp2.checked_peer
    GROUP BY tp.checking_peer ORDER BY sum DESC;
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- 16 ch_time_tracking проверяет при вставке что первая за день запись state = 1
-- и state (со значениями 1 или 2) каждой последующей за день записи не равняется предыдущей

CREATE OR REPLACE FUNCTION get_time_tracking_leaves (
    p_times int,
    p_days int
)
RETURNS TABLE (Peer text) AS $$
BEGIN
    RETURN QUERY
    WITH dates AS (
        SELECT date FROM time_tracking tt WHERE date >= CURRENT_DATE - p_days GROUP BY date
    ),
    peer_count AS (
        SELECT tt.peer, COUNT(*) FROM dates JOIN time_tracking tt ON dates.date = tt.date GROUP BY tt.peer
    )
    SELECT pc.peer FROM peer_count pc WHERE count > 2 + 2 * p_times;
    RETURN;
END;
$$ LANGUAGE plpgsql;
