CREATE TABLE IF NOT EXISTS prefix_table (
    id serial primary key,
    name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS prefix123 (
    id serial primary key,
    description TEXT
);

CREATE TABLE IF NOT EXISTS another_table (
    id serial primary key,
    value INTEGER
);

CREATE TABLE IF NOT EXISTS reference_table (
    id serial primary key,
    foreign_id bigint REFERENCES prefix_table
);



-- CALL drop_tables_with_prefix('prefix')
-- CALL drop_tables_with_prefix('refe')
-- CALL drop_tables_with_prefix('an')