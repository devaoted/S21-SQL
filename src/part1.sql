-- CREATE TYPE status AS ENUM ('start', 'success', 'failure');

-- Для пересоздания базы, раскомменчиваем и запускаем всё.
DROP TABLE IF EXISTS peers, tasks, p2p, verter, checks, transferred_points, friends, recommendations, xp, time_tracking;

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

CREATE OR REPLACE FUNCTION ch_p2p (
    p_check_id bigint,
    p_checking_peer text,
    p_state status
)
RETURNS BOOLEAN
AS $$
BEGIN
    IF (
        WITH checked AS (
            SELECT peer, task FROM checks WHERE id = p_check_id
        )
        SELECT (
            SELECT COUNT(*)
            FROM p2p JOIN checks ON p2p.check_id = checks.id
                INNER JOIN checked ON checks.peer = checked.peer
                    AND checks.task = checked.task
            WHERE p2p.checking_peer = p_checking_peer
        ) % 2 = 0
    ) THEN
        RETURN p_state = 'start';
    ELSE
        RETURN p_state != 'start';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS p2p (
    id serial PRIMARY KEY,
    check_id bigint REFERENCES checks,
    checking_peer text REFERENCES peers,
    state status,
    time time,
    CHECK (ch_p2p(check_id, checking_peer, state))
);

CREATE OR REPLACE FUNCTION ch_verter (
    p_check_id bigint
)
RETURNS BOOLEAN
RETURN EXISTS (
        SELECT * FROM p2p WHERE check_id = p_check_id AND state = 'success'
);

CREATE TABLE IF NOT EXISTS verter (
    id serial PRIMARY KEY,
    check_id bigint REFERENCES checks,
    state status,
    time time,
    CHECK (ch_verter(check_id))
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
        data_path text := '/Users/vladislavepanesnikov/Desktop/programming/school21/sber/sql/sql2_info21/datasets/';
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
CALL import_csv('friends', 'friends.csv', ';');
CALL import_csv('recommendations', 'recommends.csv', ';');
CALL import_csv('time_tracking', 'timetrack.csv', ';');
CALL import_csv('transferred_points', 'transfer.csv', ';');
CALL import_csv('xp', 'xp.csv', ';');
-- CALL import_csv('p2p', 'p2p.csv', ';');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (1, 'bread', 'start', '15:00:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (1, 'bread', 'success', '15:30:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (2, 'bread', 'start', '15:00:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (2, 'bread', 'success', '15:30:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (3, 'bread', 'start', '15:00:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (3, 'bread', 'success', '15:30:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (4, 'pizza', 'start', '15:00:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (4, 'pizza', 'success', '15:20:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (5, 'puzzle', 'start', '15:30:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (5, 'puzzle', 'success', '15:50:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (6, 'gifts', 'start', '16:00:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (6, 'gifts', 'success', '16:25:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (7, 'monster', 'start', '16:30:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (7, 'monster', 'failure', '16:45:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (8, 'toster', 'start', '15:00:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (8, 'toster', 'success', '15:20:00');
INSERT INTO p2p (check_id, checking_peer, state, time) VALUES (9, 'monster', 'start', '15:20:00');
CALL import_csv('verter', 'verter.csv', ';');


SELECT SETVAL('checks_id_seq', (SELECT MAX(id) FROM checks));
SELECT SETVAL('p2p_id_seq', (SELECT MAX(id) FROM p2p));
SELECT SETVAL('verter_id_seq', (SELECT MAX(id) FROM verter));
SELECT SETVAL('transferred_points_id_seq', (SELECT MAX(id) FROM transferred_points));
SELECT SETVAL('xp_id_seq', (SELECT MAX(id) FROM xp));
