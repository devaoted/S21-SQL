SELECT generated_date AS missing_date FROM person_visits
RIGHT JOIN v_generated_dates AS gen ON visit_date = gen.generated_date
WHERE visit_date IS NULL
ORDER BY missing_date;

-- SELECT generate_date AS missing_date FROM v_generated_date
-- EXCEPT
-- SELECT visit_date FROM person_visits
-- ORDER BY missing_date;