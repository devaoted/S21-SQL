SELECT * FROM v_persons_female
UNION
SELECT * FROM v_persons_male
ORDER BY name;