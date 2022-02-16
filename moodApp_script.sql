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
	type int not null,
	starting_time timestamptz,
	ending_time timestamptz,
	season int not null,
	amount_spent int
);

create table people (
    id uuid primary key not null,
	firstName varchar(300),
	lastName varchar(300),
	age int not null,
	gender int not null,
	social_status int not null
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
select count(*) from people;
