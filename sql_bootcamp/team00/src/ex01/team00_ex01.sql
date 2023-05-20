WITH RECURSIVE Node AS
(
    SELECT point2
            , ('{' || point1) AS path
            , cost AS total_cost
        FROM nodes n
        WHERE point1 = 'A'
    UNION
    SELECT n2.point2
            , (Node.path || ',' || n2.point1) AS path
            , Node.total_cost + n2.cost AS total_cost
    FROM nodes n2 
    JOIN Node ON n2.point1 = Node.point2
    WHERE path NOT LIKE ('%' || n2.point1 || '%')
)
, 
Way AS
(
    SELECT total_cost, (path || ',A}') AS tour
    FROM Node
    WHERE point2 = 'A' AND LENGTH(path) = 8
)
,
Min_and_max_tours AS
(
    SELECT * FROM Way
    WHERE total_cost IN ((SELECT MIN(total_cost) FROM Way), (SELECT MAX(total_cost) FROM Way))
)
SELECT * FROM Min_and_max_tours
ORDER BY total_cost, tour