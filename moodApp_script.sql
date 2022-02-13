create database MoodApp;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

create table locations (
	id uuid PRIMARY KEY not null,
	latitude double precision not null,
	longitude double precision not null,
	city varchar(500) not null
);

create table events (
	id uuid PRIMARY KEY NOT NULL,
	title varchar(500),
	location_id uuid constraint FK_locations_location_id references locations(id),
	grade int,
	status int not null,
	starting_time timestamptz,
	ending_time timestamptz
);

create table people (
    id uuid primary key not null,
	firstName varchar(300),
	lastName varchar(300),
	age int not null,
	gender int not null
);

create table event_person_relation(
	id uuid primary key not null,
	event_id uuid constraint FK_events_event_id references events(id) not null,
	person_id uuid constraint FK_people_person_id references people(id) not null
);

/*drop table event_person_relation;
drop table people;
drop table events;
drop table locations;*/
-- delete from people
-- where id = '8754b0dd-f894-4864-acd5-a3b4854bda80';

