-- CALL add_p2p('bread', 'CPP1_s21_matrix+', 'toster', 'start', '18:00');
-- CALL add_p2p('bread', 'CPP1_s21_matrix+', 'toster', 'success', '18:30');
-- SELECT date, task, COUNT(*) FROM checks GROUP BY date, task;

SELECT * FROM get_most_frequent_tasks();