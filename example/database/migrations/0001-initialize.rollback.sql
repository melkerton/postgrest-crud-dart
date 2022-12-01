SET search_path TO pgrc;

DROP FUNCTION IF EXISTS update_updated_at();
-- DROP FUNCTION IF EXISTS get_open_id();
-- DROP FUNCTION IF EXISTS get_role();

-- must be last
DROP SCHEMA IF EXISTS pgrc;
