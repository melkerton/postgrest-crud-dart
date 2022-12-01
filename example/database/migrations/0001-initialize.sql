CREATE SCHEMA IF NOT EXISTS pgrc;

GRANT USAGE ON SCHEMA pgrc TO api_anon; -- anonymous users

SET search_path TO pgrc;

-- FUNCTION
CREATE OR REPLACE FUNCTION update_updated_at()   
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := NOW();
    RETURN NEW;   
END;
$$ LANGUAGE 'plpgsql';
