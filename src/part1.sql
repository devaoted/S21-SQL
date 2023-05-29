-- Для пересоздания базы, раскомменчиваем и запускаем 

DROP VIEW IF EXISTS get_successful_checks; -- добавлено снизу для удобства
-- part1
DROP TABLE IF EXISTS peers, tasks, p2p, verter, checks, transferred_points, friends, recommendations, xp, time_tracking;
DROP PROCEDURE IF EXISTS import_csv(text, text, char), export_csv(text, text, char);
DROP FUNCTION IF EXISTS checks_status(bigint), ch_checks(bigint, text, text), ch_p2p(bigint, bigint, text, status), ch_verter(bigint, bigint, status), ch_xp(bigint, float), ch_time_tracking(bigint, date, text, int);

-- part2
DROP PROCEDURE IF EXISTS add_p2p(text, text, text, status, time), add_verter(text, text, status, time);
DROP FUNCTION IF EXISTS update_points, validate_xp_record;

-- part3
DROP FUNCTION IF EXISTS add_p2p, add_vrter, check_completed_block, get_most_frequent_tasks, get_time_tracking_leaves, get_time_tracking_no_leave, get_transferred_points, get_transferred_points_change, get_transferred_points_change2, get_xp, find_checker;

-- Enum type, дроп после всего из-за ошибок (depends on...)
DROP TYPE IF EXISTS status;

-- Таблицы
CREATE TABLE IF NOT EXISTS peers (
    nickname text PRIMARY KEY,
    birthday date
);

CREATE TABLE IF NOT EXISTS tasks (
    title text PRIMARY KEY,
    parent_task text REFERENCES tasks,
    max_xp float
);

CREATE TABLE IF NOT EXISTS checks (
    id serial PRIMARY KEY,
    peer text REFERENCES peers,
    task text REFERENCES tasks,
    date date
);

CREATE TYPE status AS ENUM ('start', 'success', 'failure');

CREATE TABLE IF NOT EXISTS p2p (
    id serial PRIMARY KEY,
    check_id bigint REFERENCES checks,
    checking_peer text REFERENCES peers,
    state status,
    time time
);

CREATE TABLE IF NOT EXISTS verter (
    id serial PRIMARY KEY,
    check_id bigint REFERENCES checks,
    state status,
    time time
);

CREATE TABLE IF NOT EXISTS transferred_points (
    id serial PRIMARY KEY,
    checking_peer text REFERENCES peers,
    checked_peer text REFERENCES peers,
    points_amount int
);

CREATE TABLE IF NOT EXISTS friends (
    id serial PRIMARY KEY,
    peer1 text REFERENCES peers,
    peer2 text REFERENCES peers
);

CREATE TABLE IF NOT EXISTS recommendations (
    id serial PRIMARY KEY,
    peer text REFERENCES peers,
    recommended_peer text REFERENCES peers
);

CREATE TABLE IF NOT EXISTS xp (
    id serial PRIMARY KEY,
    check_id bigint REFERENCES checks,
    xp_amount float
);

CREATE TABLE IF NOT EXISTS time_tracking (
    id serial PRIMARY KEY,
    peer text REFERENCES peers,
    date date,
    time time,
    state int
);

-- Процедуры импорта и экспорта CSV
CREATE OR REPLACE PROCEDURE import_csv(
    IN table_name text,
    IN csv_file text,
    IN delimiter char DEFAULT ';'
) AS 
    $$
    DECLARE
        data_path text := '/Users/vladislavepanesnikov/Desktop/programming/school21/sber/sql/info_21/datasets/';
    BEGIN
        EXECUTE format('COPY %s FROM ''%s'' DELIMITER ''%s'' CSV HEADER NULL AS ''null'';', table_name, data_path || csv_file, delimiter);
    END;
    $$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE export_csv(
    IN table_name text,
    IN csv_file text,
    IN delimiter char DEFAULT ';'
) AS 
    $$
    DECLARE
        data_path text := '/Users/vladislavepanesnikov/Desktop/programming/school21/sber/sql/sql2_info21/datasets/';
    BEGIN
        EXECUTE format('COPY %s TO ''%s'' DELIMITER ''%s'' CSV HEADER NULL AS ''null'';', table_name, data_path || csv_file, delimiter);
    END;
    $$
LANGUAGE plpgsql;

-- Создание базы данных
SET datestyle = dmy;
CALL import_csv('peers', 'peers.csv', ';');
CALL import_csv('tasks', 'tasks.csv', ';');
CALL import_csv('checks', 'checks.csv', ';');
CALL import_csv('p2p', 'p2p.csv', ';');
CALL import_csv('verter', 'verter.csv', ';');
CALL import_csv('transferred_points', 'transfer.csv', ';');
CALL import_csv('friends', 'friends.csv', ';');
CALL import_csv('recommendations', 'recommends.csv', ';');
CALL import_csv('xp', 'xp.csv', ';');
CALL import_csv('time_tracking', 'timetrack.csv', ';');

SELECT SETVAL('checks_id_seq', (SELECT MAX(id) FROM checks));
SELECT SETVAL('p2p_id_seq', (SELECT MAX(id) FROM p2p));
SELECT SETVAL('verter_id_seq', (SELECT MAX(id) FROM verter));
SELECT SETVAL('transferred_points_id_seq', (SELECT MAX(id) FROM transferred_points));
SELECT SETVAL('friends_id_seq', (SELECT MAX(id) FROM friends));
SELECT SETVAL('recommendations_id_seq', (SELECT MAX(id) FROM recommendations));
SELECT SETVAL('xp_id_seq', (SELECT MAX(id) FROM xp));
SELECT SETVAL('time_tracking_id_seq', (SELECT MAX(id) FROM time_tracking));

-- Функции проверок
CREATE OR REPLACE FUNCTION checks_status (
    p_check_id bigint
)
RETURNS status
AS $$
BEGIN
    IF (
        EXISTS (
            SELECT * FROM verter WHERE check_id = p_check_id
        )
    ) THEN
        RETURN (
            SELECT state FROM verter WHERE check_id = p_check_id ORDER BY id DESC LIMIT 1
        );
    ELSE
        RETURN (
            SELECT state FROM p2p WHERE check_id = p_check_id ORDER BY id DESC LIMIT 1
        );
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ch_checks (
    p_check_id bigint,
    p_peer text,
    p_task text
)
RETURNS BOOLEAN
AS $$
DECLARE 
    v_parent_task text;
BEGIN
    v_parent_task := (
        SELECT parent_task FROM tasks WHERE title = p_task
    );
    RETURN v_parent_task IS NULL OR EXISTS (
        SELECT * FROM checks WHERE peer = p_peer AND task = v_parent_task
            AND checks_status(id) = 'success'
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ch_p2p (
    p_id bigint,
    p_check_id bigint,
    p_checking_peer text,
    p_state status
)
RETURNS BOOLEAN
AS $$
DECLARE
    count int;
BEGIN
    count := (
        WITH checked AS (
            SELECT peer, task FROM checks WHERE id = p_check_id
        )
        SELECT COUNT(*)
        FROM p2p JOIN checks ON check_id = checks.id
            INNER JOIN checked ON checks.peer = checked.peer
                AND checks.task = checked.task
        WHERE checking_peer = p_checking_peer
            AND p2p.id < p_id
    );
    IF (
        p_state = 'start'
    ) THEN
        RETURN count % 2 = 0;
    ELSE
        RETURN count % 2 = 1;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ch_verter (
    p_id bigint,
    p_check_id bigint,
    p_state status
)
RETURNS BOOLEAN
AS $$
DECLARE
    count int;
BEGIN
    IF (
        EXISTS (
            SELECT * FROM p2p WHERE check_id = p_check_id AND state = 'success'
        )
    ) THEN
        count := (
            SELECT COUNT(*) FROM verter
            WHERE check_id = p_check_id AND verter.id < p_id
        );
        IF (
            p_state = 'start'
        ) THEN
            RETURN count % 2 = 0;
        ELSE
            RETURN count % 2 = 1;
        END IF;
    ELSE
        RETURN False;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ch_xp (
    p_check_id bigint,
    p_xp_amount float
)
RETURNS BOOLEAN
AS $$
BEGIN
    RETURN (
        (SELECT max_xp FROM tasks WHERE title = (
            SELECT task FROM checks WHERE id = p_check_id
        )) >= p_xp_amount AND (SELECT checks_status(p_check_id) = 'success')
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ch_time_tracking (
    p_id bigint,
    p_date date,
    p_peer text,
    p_state int
)
RETURNS BOOLEAN
AS $$
DECLARE 
    v_date date;
BEGIN
    v_date := (
        SELECT date FROM time_tracking WHERE id < p_id ORDER BY id DESC LIMIT 1
    );
    IF (
        v_date = p_date
    ) THEN
        RETURN (
            SELECT p_state BETWEEN 1 AND 2 AND (SELECT state FROM time_tracking
                WHERE id < p_id AND date = p_date AND peer = p_peer
                ORDER BY id DESC LIMIT 1) != p_state
        );
    ELSE
        RETURN (
            WITH compare AS (
                SELECT state, COUNT(*) FROM time_tracking WHERE date = v_date GROUP BY state
            )
            SELECT p_state = 1
                AND COALESCE((SELECT count FROM compare WHERE state = 1), 0)
                = COALESCE((SELECT count FROM compare WHERE state = 2), 0)
        );
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE VIEW get_successful_checks AS
    SELECT peer, task, date FROM checks
    WHERE checks_status(id) = 'success';

-- Добавление проверок
ALTER TABLE checks ADD CHECK (ch_checks(id, peer, task));
ALTER TABLE verter ADD CHECK (ch_verter(id, check_id, state));
ALTER TABLE p2p ADD CHECK (ch_p2p(id, check_id, checking_peer, state));
ALTER TABLE xp ADD CHECK (ch_xp(check_id, xp_amount));
ALTER TABLE time_tracking ADD CHECK (ch_time_tracking(id, date, peer, state));
