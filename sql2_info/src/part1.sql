-- CREATE TYPE status AS ENUM ('start', 'success', 'failure');

-- Для пересоздания базы, раскомменчиваем и запускаем всё.
-- DROP TABLE peers, tasks, p2p, verter, checks, transferred_points, friends, recommendations, xp, time_tracking;

-- Таблицы
CREATE TABLE IF NOT EXISTS peers (
    nickname text primary key,
    birthday date
);

CREATE TABLE IF NOT EXISTS tasks (
    title text primary key,
    parent_task text,
    max_xp float
);

CREATE TABLE IF NOT EXISTS p2p (
    id serial primary key,
    check_id bigint,
    checking_peer text,
    state status,
    time time
);

CREATE TABLE IF NOT EXISTS verter (
    id serial primary key,
    check_id bigint,
    state status,
    time time
);

CREATE TABLE IF NOT EXISTS checks (
    id serial primary key,
    peer text,
    task text,
    date date
);

CREATE TABLE IF NOT EXISTS transferred_points (
    id serial primary key,
    checking_peer text,
    checked_peer text,
    points_amount float
);

CREATE TABLE IF NOT EXISTS friends (
    id serial primary key,
    peer1 text,
    peer2 text
);

CREATE TABLE IF NOT EXISTS recommendations (
    id serial primary key,
    peer text,
    recommended_peer text
);

CREATE TABLE IF NOT EXISTS xp (
    id serial primary key,
    check_id bigint,
    xp_amount float
);

CREATE TABLE IF NOT EXISTS time_tracking (
    id serial primary key,
    peer text,
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
        EXECUTE format('COPY %s FROM ''%s'' DELIMITER ''%s'' CSV HEADER;', table_name, data_path || csv_file, delimiter);
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
        EXECUTE format('COPY %s TO ''%s'' DELIMITER ''%s'' CSV HEADER;', table_name, data_path || csv_file, delimiter);
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
CALL import_csv('verter', 'verter.csv', ';');
CALL import_csv('xp', 'xp.csv', ';');
CALL import_csv('p2p', 'p2p.csv', ';');

SELECT SETVAL('checks_id_seq', (SELECT MAX(id) FROM checks));
SELECT SETVAL('p2p_id_seq', (SELECT MAX(id) FROM p2p));
SELECT SETVAL('verter_id_seq', (SELECT MAX(id) FROM verter));
SELECT SETVAL('transferred_points_id_seq', (SELECT MAX(id) FROM transferred_points));
SELECT SETVAL('xp_id_seq', (SELECT MAX(id) FROM xp));