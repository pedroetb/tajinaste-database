\c tajinaste

DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tajinaste_guest') THEN
		CREATE ROLE tajinaste_guest NOLOGIN;
	END IF;
END
$$;
GRANT tajinaste_guest TO postgres;
GRANT USAGE ON SCHEMA public, auth TO tajinaste_guest;
GRANT SELECT ON TABLE pg_authid, auth.users TO tajinaste_guest;
GRANT EXECUTE ON FUNCTION login(text,text) TO tajinaste_guest;

DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tajinaste_user') THEN
		CREATE ROLE tajinaste_user NOLOGIN;
	END IF;
END
$$;
GRANT tajinaste_user TO postgres;
GRANT USAGE ON SCHEMA api TO tajinaste_user;
GRANT SELECT(id, uuid, name, surname, entry, regular, federated, photo) ON api.people TO tajinaste_user;

DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tajinaste_admin') THEN
		CREATE ROLE tajinaste_admin NOLOGIN;
	END IF;
END
$$;
GRANT tajinaste_admin TO postgres;
GRANT USAGE ON SCHEMA api TO tajinaste_admin;
GRANT ALL ON api.people TO tajinaste_admin;
GRANT USAGE, SELECT ON SEQUENCE api.people_id_seq TO tajinaste_admin;
