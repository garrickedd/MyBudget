CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
	id_user uuid NOT NULL DEFAULT uuid_generate_v4(),
    first_name varchar(15) NOT NULL,
    last_name varchar(15) NOT NULL,
	email varchar(255) NOT NULL,
	pass varchar(255) NOT NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL,
	CONSTRAINT user_pk PRIMARY KEY (id_user),
	CONSTRAINT email_un UNIQUE (email)
);