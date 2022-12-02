SET search_path TO pgrc;

CREATE TABLE IF NOT EXISTS "todo" (
    id SERIAL PRIMARY KEY,
    item VARCHAR(128) NOT NULL,
    details TEXT
);

-- GRANTS (Absolutely insecure.)
GRANT SELECT ON "todo" TO api_anon;
GRANT ALL ON "todo" TO api_anon;
GRANT USAGE, SELECT ON SEQUENCE "todo_id_seq" TO api_anon;


