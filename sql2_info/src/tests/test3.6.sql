SELECT date, task, COUNT(*) FROM checks GROUP BY date, task;

SELECT * FROM get_most_frequent_tasks();