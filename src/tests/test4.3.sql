CREATE TABLE IF NOT EXISTS trigger_table (
    id serial primary key,
    name VARCHAR(50)
);

CREATE OR REPLACE FUNCTION test_trigger_1()
RETURNS TRIGGER AS $$
BEGIN
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_1
    BEFORE UPDATE ON trigger_table
    FOR EACH ROW
    EXECUTE FUNCTION test_trigger_1();

CREATE OR REPLACE FUNCTION test_trigger_2()
RETURNS TRIGGER AS $$
BEGIN
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_2
    AFTER DELETE ON trigger_table
    FOR EACH ROW
    EXECUTE FUNCTION test_trigger_2();


CALL destroy_dml_triggers(5);