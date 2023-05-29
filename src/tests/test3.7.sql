CALL add_p2p('toster', 'C5_21_matrix', 'bread', 'start', '16:30');
CALL add_p2p('toster', 'C5_21_matrix', 'bread', 'success', '17:00');
CALL add_p2p('toster', 'C6_SmartCalc_v1.0', 'bread', 'start', '17:00');
CALL add_p2p('toster', 'C6_SmartCalc_v1.0', 'bread', 'success', '17:30');
CALL add_p2p('toster', 'C7_3DViewer_v1.0', 'bread', 'start', '17:30');
CALL add_p2p('toster', 'C7_3DViewer_v1.0', 'bread', 'success', '18:00');
CALL add_p2p('toster', 'C5_21_matrix', 'bread', 'start', '18:00');
CALL add_p2p('toster', 'C5_21_matrix', 'bread', 'success', '18:30');
CALL add_p2p('toster', 'CPP1_s21_matrix+', 'bread', 'start', '18:30');
CALL add_p2p('toster', 'CPP1_s21_matrix+', 'bread', 'success', '19:00');

SELECT * FROM get_successful_checks;
SELECT * FROM check_completed_block('C');
SELECT * FROM check_completed_block('CPP');

