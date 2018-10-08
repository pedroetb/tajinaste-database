\c tajinaste

CREATE SCHEMA IF NOT EXISTS api;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS api.people (
	id smallserial PRIMARY KEY,
	uuid uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
	dni character(9) UNIQUE NOT NULL,
	name text NOT NULL CHECK(length(name) < 64),
	surname text NOT NULL CHECK(length(surname) < 64),
	sex character(1),
	email text,
	phone1 character(13),
	phone2 character(13),
	occupation text,
	notes text,
	province text,
	locality text,
	cp character(5),
	address text,
	birth date,
	entry date NOT NULL,
	regular boolean NOT NULL DEFAULT false,
	federated boolean NOT NULL DEFAULT false,
	photo uuid,
	created timestamp NOT NULL DEFAULT now()
);
