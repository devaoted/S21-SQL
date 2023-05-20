-- Read committed

-- Session 1
BEGIN;

-- Session 2
BEGIN;

-- Session 1
SELECT SUM(rating) FROM pizzeria; -- 21.9

-- Session 2
UPDATE pizzeria SET rating = 1 WHERE name = 'Pizza Hut';
COMMIT;

-- Session 1
SELECT SUM(rating) FROM pizzeria; -- 19.9
COMMIT;
SELECT SUM(rating) FROM pizzeria; -- 19.9

-- Session 2
SELECT SUM(rating) FROM pizzeria; -- 19.9