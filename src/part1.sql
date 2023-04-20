-- Enum status
CREATE TYPE status AS ENUM ('start', 'success', 'failure');

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
    date date,
    time time,
    state int
);

-- Процедуры импорта и экспорта CSV

-- 1. Peers
CREATE OR REPLACE PROCEDURE import_peers_csv(IN delimiter TEXT) AS 
    $$
    COPY peers (
        nickname,
        birthday
    )
    FROM filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

CREATE OR REPLACE PROCEDURE export_peers_csv(IN delimiter TEXT) AS 
    $$
    COPY peers (
        nickname,
        birthday
    )
    TO filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

-- 2. Tasks
CREATE OR REPLACE PROCEDURE import_tasks_csv(IN delimiter TEXT) AS 
    $$
    COPY tasks (
        title, 
        parent_task,
        max_xp
    )
    FROM filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

CREATE OR REPLACE PROCEDURE export_tasks_csv(IN delimiter TEXT) AS 
    $$
    COPY tasks (
        title, 
        parent_task,
        max_xp
    )
    TO filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

-- 3. p2p
CREATE OR REPLACE PROCEDURE import_p2p_csv(IN delimiter TEXT) AS 
    $$
    COPY p2p (
        id,
        check_id,
        checking_peer,
        state, 
        time
    )
    FROM filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

CREATE OR REPLACE PROCEDURE export_p2p_csv(IN delimiter TEXT) AS 
    $$
    COPY p2p (
        id,
        check_id,
        checking_peer,
        state, 
        time
    )
    TO filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

-- 4. verter
CREATE OR REPLACE PROCEDURE import_verter_csv(IN delimiter TEXT) AS 
    $$
    COPY verter (
        id,
        check_id,
        state,
        time
    )
    FROM filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

CREATE OR REPLACE PROCEDURE export_verter_csv(IN delimiter TEXT) AS 
    $$
    COPY verter (
        id,
        check_id,
        state,
        time
    )
    TO filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

-- 5. checks
CREATE OR REPLACE PROCEDURE import_checks_csv(IN delimiter TEXT) AS 
    $$
    COPY checks (
        id,
        peer,
        task,
        date
    )
    FROM filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

CREATE OR REPLACE PROCEDURE export_checks_csv(IN delimiter TEXT) AS 
    $$
    COPY checks (
        id,
        peer,
        task,
        date
    )
    TO filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

-- 7. transferred_points
CREATE OR REPLACE PROCEDURE import_transfer_csv(IN delimiter TEXT) AS 
    $$
    COPY transferred_points (
        id,
        checking_peer,
        checked_peer,
        points_amount
    )
    FROM filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

CREATE OR REPLACE PROCEDURE export_transfer_csv(IN delimiter TEXT) AS 
    $$
    COPY transferred_points (
        id,
        checking_peer,
        checked_peer,
        points_amount
    )
    TO filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

--  8. friends
CREATE OR REPLACE PROCEDURE import_friends_csv(IN delimiter TEXT) AS 
    $$
    COPY friends (
        id,
        peer1,
        peer2
    )
    FROM filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

CREATE OR REPLACE PROCEDURE export_friends_csv(IN delimiter TEXT) AS 
    $$
    COPY friends (
        id,
        peer1,
        peer2
    )
    TO filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

-- 9. recommendations
CREATE OR REPLACE PROCEDURE import_recs_csv(IN delimiter TEXT) AS 
    $$
    COPY recommendations (
        id,
        peer,
        recommended_peer
    )
    FROM filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

CREATE OR REPLACE PROCEDURE export_recs_csv(IN delimiter TEXT) AS 
    $$
    COPY recommendations (
        id,
        peer,
        recommended_peer
    )
    TO filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

-- 10. xp 
CREATE OR REPLACE PROCEDURE import_xp_csv(IN delimiter TEXT) AS 
    $$
    COPY xp (
        id,
        check_id,
        xp_amount
    )
    FROM filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

CREATE OR REPLACE PROCEDURE export_xp_csv(IN delimiter TEXT) AS 
    $$
    COPY xp (
        id,
        check_id,
        xp_amount
    )
    TO filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

-- 11. time_tracking 
CREATE OR REPLACE PROCEDURE import_track_csv(IN delimiter TEXT) AS 
    $$
    COPY time_tracking (
        id,
        date,
        time, 
        state
    )
    FROM filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;

CREATE OR REPLACE PROCEDURE export_track_csv(IN delimiter TEXT) AS 
    $$
    COPY time_tracking (
        id,
        date,
        time, 
        state
    )
    TO filepath
    WITH DELIMITER delimiter
    CSV HEADER;
    $$ 
LANGUAGE sql;