-- CREATE TYPE status AS ENUM ('start', 'success', 'failure');

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
    date date,
    time time,
    state int
);

-- Процедуры импорта и экспорта
CREATE OR REPLACE PROCEDURE import_peers_csv(IN delimiter TEXT) AS 
    $$
    COPY orders (
        id,
        user_id,
        product_id,
        quantity,
        total_price
    )
    FROM filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;