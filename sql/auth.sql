\c tajinaste

CREATE SCHEMA IF NOT EXISTS auth;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS auth.users (
	id smallserial PRIMARY KEY,
	uuid uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
	email text UNIQUE NOT NULL CHECK(email ~* '^.+@.+\..+$'),
	password text NOT NULL CHECK(length(password) < 128),
	role text NOT NULL CHECK(length(role) < 64),
	name text NOT NULL,
	photo uuid,
	created timestamp NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION
auth.check_role_exists() RETURNS TRIGGER AS $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM pg_roles AS r WHERE r.rolname = NEW.role) THEN
		RAISE foreign_key_violation USING MESSAGE = 'unknown database role: ' || NEW.role;
		RETURN NULL;
	END IF;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS ensure_user_role_exists ON auth.users;
CREATE CONSTRAINT TRIGGER ensure_user_role_exists
	AFTER INSERT OR UPDATE ON auth.users
	FOR EACH ROW
	EXECUTE PROCEDURE auth.check_role_exists();

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION
auth.encrypt_password() RETURNS TRIGGER AS $$
BEGIN
	IF TG_OP = 'INSERT' OR NEW.password <> OLD.password THEN
		NEW.password = crypt(NEW.password, gen_salt('bf'));
	END IF;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS encrypt_password ON auth.users;
CREATE TRIGGER encrypt_password
	BEFORE INSERT OR UPDATE ON auth.users
	FOR EACH ROW
	EXECUTE PROCEDURE auth.encrypt_password();

CREATE OR REPLACE FUNCTION
auth.get_user_data(email text, password text) RETURNS text AS $$
BEGIN
	RETURN (
		SELECT role
		FROM auth.users
		WHERE users.email = get_user_data.email
		AND users.password = crypt(get_user_data.password, users.password)
	);
END;
$$ LANGUAGE plpgsql;

DROP TYPE IF EXISTS user_data;
CREATE TYPE user_data AS (
	id smallint,
	uuid text,
	email text,
	role text,
	name text,
	photo text
);

CREATE OR REPLACE FUNCTION
login(email text, password text) RETURNS user_data AS $$
DECLARE
	role text;
	data user_data;
BEGIN
	SELECT auth.get_user_data(email, password) INTO role;
	IF role IS NULL THEN
		RAISE invalid_password USING MESSAGE = 'invalid user or password';
		RETURN NULL;
	END IF;
	SELECT id, uuid, u.email, u.role, name, photo
	FROM auth.users u
	WHERE login.email = u.email
	INTO data;
	RETURN data;
END;
$$ LANGUAGE plpgsql;
