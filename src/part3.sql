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

-- 2



