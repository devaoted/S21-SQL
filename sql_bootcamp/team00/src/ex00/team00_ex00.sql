CREATE TABLE IF NOT EXISTS nodes
(
    id BIGINT primary key,
    point1 VARCHAR(1) NOT NULL,
    point2 VARCHAR(1) NOT NULL,
    cost INT NOT NULL
);

INSERT INTO nodes VALUES (1, 'A', 'B', 10);
INSERT INTO nodes VALUES (2, 'A', 'C', 15);
INSERT INTO nodes VALUES (3, 'A', 'D', 20);
INSERT INTO nodes VALUES (4, 'B', 'A', 10);
INSERT INTO nodes VALUES (5, 'B', 'C', 35);
INSERT INTO nodes VALUES (6, 'B', 'D', 25);
INSERT INTO nodes VALUES (7, 'C', 'A', 15);
INSERT INTO nodes VALUES (8, 'C', 'B', 35);
INSERT INTO nodes VALUES (9, 'C', 'D', 30);
INSERT INTO nodes VALUES (10, 'D', 'A', 20);
INSERT INTO nodes VALUES (11, 'D', 'B', 25);
INSERT INTO nodes VALUES (12, 'D', 'C', 30);

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
Min_tours AS
(
    SELECT * FROM Way
    WHERE total_cost IN (SELECT MIN(total_cost) FROM Way)
)
SELECT * FROM Min_tours
ORDER BY total_cost, tour