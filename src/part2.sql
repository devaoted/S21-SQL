-- DROP PROCEDURE IF EXISTS add_p2p(text, text, text, status, time), add_verter(text, text, status, time);

-- 1
CREATE OR REPLACE PROCEDURE add_p2p(
    IN p_peer text,
    IN p_task text,
    IN p_checking_peer text,
    IN p_state status,
    IN p_time time
)
AS $$
DECLARE 
    v_check_id bigint;
BEGIN
    IF (p_state = 'start') THEN
        INSERT INTO checks (peer, task, date)
        VALUES (p_peer, p_task, CURRENT_DATE);
        v_check_id := currval(pg_get_serial_sequence('checks', 'id'));
    ELSE
        v_check_id := (
            WITH p2p_checks AS (
                SELECT check_id, COUNT(*)
                FROM p2p JOIN checks ON check_id = checks.id
                WHERE peer = p_peer AND task = p_task AND checking_peer = p_checking_peer
                    AND time <= p_time
                GROUP BY check_id
            )
            SELECT check_id FROM p2p_checks WHERE count = 1
        );

        IF v_check_id IS NULL THEN
            RAISE 'p2p check was not started for: peer %, task %, checking_peer %, time <= %', p_peer, p_task, p_checking_peer, p_time;
        END IF;
    END IF;

    INSERT INTO P2P (check_id, checking_peer, state, time)
    VALUES (v_check_id, p_checking_peer, p_state, p_time);
END;
$$
LANGUAGE plpgsql;

-- 2
CREATE OR REPLACE PROCEDURE add_verter(
    IN p_peer text,
    IN p_task text,
    IN p_state status,
    IN p_time time
)
AS $$
DECLARE
    v_check_id bigint;
BEGIN
    v_check_id := (
        SELECT check_id FROM p2p JOIN checks ON check_id = checks.id
        WHERE peer = p_peer AND task = p_task AND state = 'success' AND time <= p_time
        ORDER BY date DESC, time DESC LIMIT 1
    );

    IF v_check_id IS NULL THEN
        RAISE 'p2p check was not successfully completed for: peer %, task %, time <= %', p_peer, p_task, p_time;
    END IF;

    IF (
        p_state != 'start' AND NOT EXISTS (
            SELECT * FROM verter WHERE check_id = v_check_id AND time <= p_time
        )
    ) THEN
        RAISE 'verter check was not started for: check_id %, time <= %', v_check_id, p_time;
    END IF;

    INSERT INTO verter (check_id, state, time)
    VALUES (v_check_id, p_state, p_time);
END;
$$
LANGUAGE plpgsql;

-- 3
CREATE OR REPLACE FUNCTION update_points()
RETURNS TRIGGER AS $$
DECLARE
    new_verified_peer text;
    new_verifier_peer text;
BEGIN
    new_verifier_peer := NEW.checking_peer;
    SELECT peer INTO new_verified_peer FROM checks WHERE checks.id = NEW.check_id;
    -- Проверяем, что добавленная запись в таблицу P2P имеет статус "начало"
    IF NEW.state = 'start' THEN
        -- Ищем запись в таблице TransferredPoints, соответствующую паре проверяемый-проверяющий
        -- и увеличиваем количество переданных пир поинтов на 1
        UPDATE transferred_points
        SET points_amount = points_amount + 1
        WHERE checked_peer = new_verified_peer
            AND checking_peer = new_verifier_peer;

        -- Если запись не найдена, то создаем новую запись в таблице TransferredPoints
        IF NOT FOUND THEN
            INSERT INTO transferred_points (checked_peer, checking_peer, points_amount)
            VALUES (new_verified_peer, new_verifier_peer, 1);
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER after_p2p_start
AFTER INSERT ON p2p
FOR EACH ROW
EXECUTE FUNCTION update_points();

-- 4
CREATE OR REPLACE FUNCTION validate_xp_record()
RETURNS TRIGGER AS $$
DECLARE 
    task_name text;
BEGIN
    -- Проверка корректности добавляемой записи
    SELECT task INTO task_name FROM checks WHERE checks.id = NEW.check_id;

    IF NEW.xp_amount > (SELECT max_xp FROM tasks WHERE title = task_name) THEN
        RAISE EXCEPTION 'Количество XP превышает максимальное доступное для задачи';
    END IF;

    IF (
        SELECT checks_status(NEW.check_id) != 'success'
    ) THEN
        RAISE EXCEPTION 'Поле Check должно ссылаться на успешную проверку';
    END IF;

    -- Запись прошла проверку, добавляем её в таблицу XP
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
            PERFORM SETVAL('xp_id_seq', (SELECT MAX(id) FROM xp));
        RAISE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER xp_record_validation
BEFORE INSERT ON xp
FOR EACH ROW
EXECUTE FUNCTION validate_xp_record();