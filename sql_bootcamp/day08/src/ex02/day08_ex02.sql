-- Repeatable read

-- Session 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Session 2
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Session 1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut'; -- 5

-- Session 2
SELECT * FROM pizzeria WHERE name = 'Pizza Hut'; -- 5

-- Session 1
UPDATE pizzeria SET rating = 4 WHERE name = 'Pizza Hut';

-- Session 2
UPDATE pizzeria SET rating = 3.6 WHERE name = 'Pizza Hut';

-- Session 1
COMMIT; -- error in session 2

-- Session 2
COMMIT; -- rollback

-- Session 1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut'; -- 4

-- Session 2
SELECT * FROM pizzeria WHERE name = 'Pizza Hut'; -- 4