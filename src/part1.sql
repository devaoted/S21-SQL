-- enum status
-- CREATE TYPE status AS ENUM ('start', 'success', 'failure');

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
    id bigint primary key,
    check_id bigint,
    checking_peer text,
    state status,
    time time
);

CREATE TABLE IF NOT EXISTS verter (
    id bigint primary key,
    check_id bigint,
    state status,
    time time
);

CREATE TABLE IF NOT EXISTS checks (
    id bigint primary key,
    peer text,
    task text,
    date date
);

CREATE TABLE IF NOT EXISTS transferred_points (
    id bigint primary key,
    checking_peer text,
    checked_peer text,
    points_amount float
);

CREATE TABLE IF NOT EXISTS friends (
    id bigint primary key,
    peer1 text,
    peer2 text
);

CREATE TABLE IF NOT EXISTS recommendations (
    id bigint primary key,
    peer text,
    recommended_peer text
);

CREATE TABLE IF NOT EXISTS xp (
    id bigint primary key,
    check_id bigint,
    xp_amount float
);

CREATE TABLE IF NOT EXISTS time_tracking (
    id bigint primary key,
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