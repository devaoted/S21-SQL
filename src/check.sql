CALL add_p2p('toster', 'gifts', 'C7_3DViewer_v1.0', 'start', '15:35');
CALL add_p2p('gifts', 'toster', 'C7_3DViewer_v1.0', 'start', '15:40');
-- CALL add_p2p('hello', 'hello', 'C7_3DViewer_v1.0', 'success', '15:40');

-- CALL add_verter('pizza', 'C7_3DViewer_v1.0', 'start', '16:35');
-- CALL add_verter('pizza', 'C7_3DViewer_v1.0', 'success', '16:40');

SELECT * 
    FROM transferred_points tp1
    LEFT JOIN transferred_points tp2 ON tp1.checked_peer = tp2.checking_peer AND tp1.checking_peer = tp2.checked_peer
    WHERE tp1.checking_peer < tp1.checked_peer
        OR (tp1.checking_peer > tp1.checked_peer AND tp2.checked_peer is NULL);
-- DELETE FROM verter WHERE id = 6;
-- INSERT INTO xp (check_id, xp_amount)
-- VALUES (
--     5, 300
-- );