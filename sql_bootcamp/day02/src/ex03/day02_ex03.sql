WITH cte_date
AS 
(
SELECT missing_date::date
FROM generate_series('2022-01-01', '2022-01-10', interval '1 day') AS missing_date
)
SELECT missing_date 
FROM cte_date
LEFT JOIN (SELECT person_id, visit_date FROM person_visits 
           WHERE person_id = 1 OR person_id = 2) AS visits
ON missing_date = visit_date
WHERE visits.visit_date is NULL