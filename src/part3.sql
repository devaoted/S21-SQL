-- DROP FUNCTION IF EXISTS add_p2p, add_vrter, check_completed_block, get_most_frequent_tasks, get_time_tracking_leaves, get_time_tracking_no_leave, get_transferred_points, get_transferred_points_change, get_transferred_points_change2, get_xp
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
END;
$$ LANGUAGE plpgsql;

-- 2 Тут можно добавить проверку WHERE checks_status(check_id) = 'success'
-- но так как ch_xp проверяет это при вставке, то нет необходимости

CREATE OR REPLACE FUNCTION get_xp()
RETURNS TABLE (Peer text, Task text, XP float) AS $$
BEGIN
    RETURN QUERY
    SELECT checks.peer, checks.task, xp_amount FROM xp JOIN checks ON check_id = checks.id;
    -- WHERE checks_status(checks.id) = 'success';
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
END;
$$ LANGUAGE plpgsql;

-- 4

CREATE OR REPLACE FUNCTION get_transferred_points_change()
RETURNS TABLE (Peer text, PointsChange int) AS $$
BEGIN
    RETURN QUERY
    WITH add AS (
        SELECT checking_peer AS peer, SUM(points_amount) FROM transferred_points GROUP BY checking_peer
    ), deduct AS (
        SELECT checked_peer AS peer, -SUM(points_amount) FROM transferred_points GROUP BY checked_peer
    )
    SELECT ad.peer, CAST(SUM(sum) AS int) FROM (
        SELECT * FROM add UNION SELECT * FROM deduct
    ) ad GROUP BY ad.peer ORDER BY sum DESC;
END;
$$ LANGUAGE plpgsql;

-- 5

CREATE OR REPLACE FUNCTION get_transferred_points_change2()
RETURNS TABLE (Peer text, PointsChange int) AS $$
BEGIN
    RETURN QUERY
    WITH add AS (
        SELECT Peer1 AS peer, SUM(PointsAmount) FROM get_transferred_points() GROUP BY Peer1
    ), deduct AS (
        SELECT Peer2 AS peer, -SUM(PointsAmount) FROM get_transferred_points() GROUP BY Peer2
    )
    SELECT ad.peer, CAST(SUM(sum) AS int) FROM (
        SELECT * FROM add UNION SELECT * FROM deduct
    ) ad GROUP BY ad.peer ORDER BY sum DESC;
END;
$$ LANGUAGE plpgsql;

-- 6 

CREATE OR REPLACE FUNCTION get_most_frequent_tasks()
RETURNS TABLE (Day date, Task text) AS $$
BEGIN
    RETURN QUERY
    WITH task_counts AS (
        SELECT c.date, c.task, COUNT(*) AS check_count
        FROM checks c
        GROUP BY c.date, c.task
    )
    SELECT tc.date, tc.task
    FROM task_counts tc
    JOIN (
        SELECT date, MAX(check_count) AS max_count
        FROM task_counts
        GROUP BY date
    ) mc
        ON tc.date = mc.date AND tc.check_count = mc.max_count
    ORDER BY 1 DESC, 2 ASC;
END;
$$ LANGUAGE plpgsql;

-- 7

CREATE OR REPLACE FUNCTION check_completed_block(prefix text)
RETURNS TABLE (peer text, last_task_completion_date date) AS $$
DECLARE
    count_chain int;
BEGIN
    WITH RECURSIVE task_chain AS (
        SELECT title, parent_task, 1 AS depth
        FROM tasks
        WHERE title ~ ('^' || prefix || '[1-9]') AND parent_task IS NULL
        UNION ALL
        SELECT t.title, t.parent_task, tc.depth + 1
        FROM tasks t
        JOIN task_chain tc ON t.parent_task = tc.title
    )
    SELECT MAX(depth) INTO count_chain FROM task_chain;

    RAISE NOTICE 'Depth %', count_chain;

    RETURN QUERY
    SELECT c.peer, MAX(c.date) AS last_task_completion_date
    FROM checks c
    GROUP BY c.peer
    HAVING count_chain = (
        SELECT COUNT(DISTINCT sc.task)
        FROM get_successful_checks sc
        WHERE sc.task ~ ('^' || prefix || '[1-9]') AND sc.peer = c.peer
    );
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
END;
$$ LANGUAGE plpgsql;
