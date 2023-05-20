--  Read committed

-- Session 1
SHOW TRANSACTION ISOLATION LEVEL;
BEGIN;

-- Session 2
SHOW TRANSACTION ISOLATION LEVEL;
BEGIN;

-- Session 1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut'; -- 5

-- Session 2
SELECT * FROM pizzeria WHERE name = 'Pizza Hut'; -- 5

-- Session 1
UPDATE pizzeria SET rating = 4 WHERE name = 'Pizza Hut';

-- Session 2
UPDATE pizzeria SET rating = 3.6 WHERE name = 'Pizza Hut';

-- Session 1 
SELECT * FROM pizzeria WHERE name = 'Pizza Hut'; -- 3.6

-- Session 2
SELECT * FROM pizzeria WHERE name = 'Pizza Hut'; -- 3.6
