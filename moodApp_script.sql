create database MoodApp;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

create table locations (
	id uuid PRIMARY KEY NOT NULL,
	latitude double precision not null,
	longitude double precision not null,
	city varchar(500) not null
);

create table events (
	id uuid PRIMARY KEY NOT NULL,
	location_id uuid constraint FK_locations_location_id references locations(id) not null,
	grade int,
	status smallint,
	starting_time timestamptz,
	ending_time timestamptz
);

create table people (
    id uuid primary key not null,
	firstName varchar(300),
	lastName varchar(300),
	age int not null
);

create table event_person_relation(
	id uuid primary key not null,
	event_id uuid constraint FK_events_event_id references events(id) not null,
	person_id uuid constraint FK_people_person_id references people(id) not null
);


/*drop table events;
drop table locations;
drop table people;
drop table event_person_relation;*/


/*delete from people where firstName = 'Griz';*/