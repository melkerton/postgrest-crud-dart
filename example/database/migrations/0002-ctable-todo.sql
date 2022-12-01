SET search_path TO pgrc;

CREATE TABLE IF NOT EXISTS "todo" (
    id SERIAL PRIMARY KEY,
    item VARCHAR(128) NOT NULL,
    details TEXT
);

-- GRANTS
GRANT SELECT ON "todo" TO api_anon;
GRANT ALL ON "todo" TO api_anon;
GRANT USAGE, SELECT ON SEQUENCE "todo_id_seq" TO api_anon;

-- TRIGGERS
CREATE TRIGGER todo_update_updated_at
    BEFORE UPDATE ON "todo"
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

