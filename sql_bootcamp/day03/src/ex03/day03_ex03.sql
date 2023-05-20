WITH 
women_visits AS (
    SELECT p.name AS pizzeria_name FROM pizzeria AS p
    JOIN person_visits AS pv ON pv.pizzeria_id = p.id
    JOIN person ON person.id = pv.person_id
    WHERE person.gender = 'female'),
men_visits AS (
    SELECT p.name AS pizzeria_name FROM pizzeria AS p
    JOIN person_visits AS pv ON pv.pizzeria_id = p.id
    JOIN person ON person.id = pv.person_id
    WHERE person.gender = 'male'),
women_only AS (
    SELECT * FROM women_visits
    EXCEPT ALL
    SELECT * FROM men_visits
),
men_only AS (
    SELECT * FROM men_visits
    EXCEPT ALL
    SELECT * FROM women_visits
)

SELECT * FROM women_only
UNION ALL
SELECT * FROM men_only
ORDER BY pizzeria_name;