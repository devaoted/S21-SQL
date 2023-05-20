SELECT address, 
MAX(age) - MIN(age)/MAX(age)::float AS formula, 
ROUND(AVG(age), 2) AS average
, 
MAX(age) - MIN(age)/MAX(age)::float > AVG(age) AS comparison
FROM person
GROUP BY address
ORDER BY 1;