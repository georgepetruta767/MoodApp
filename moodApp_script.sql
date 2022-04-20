create database MoodApp;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

create table locations (
	id uuid PRIMARY KEY not null,
	latitude double precision not null,
	longitude double precision not null,
	city varchar(500) not null,
	country varchar(500) not null
);

create table Context(
    id uuid primary key not null);
/*    aspNetUserId text constraint FK_AspNetUsers_AspNetUser_id references "AspNetUsers"("Id") not null
*/

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
	amount_spent int,
	context_id uuid constraint FK_Context_Context_id references Context(id) not null
);

create table people (
    id uuid primary key not null,
	firstName varchar(300),
	lastName varchar(300),
	age int not null,
	gender int not null,
	social_status int not null,
	context_id uuid constraint FK_Context_Context_id references Context(id) not null
);

create table event_person_relation(
	id uuid primary key not null,
	event_id uuid constraint FK_events_event_id references events(id) not null,
	person_id uuid constraint FK_people_person_id references people(id) not null
);

drop table event_person_relation;
drop table people;
drop table events;
drop table locations;
drop table Context;

alter table Context
add aspNetUserId text constraint FK_AspNetUsers_AspNetUser_id references "AspNetUsers"("Id") not null;

delete from Context
    where aspNetUserId = '71c1960d-6ced-4281-948a-4369a1e60fdb';


delete from "AspNetUsers"
where "Id" = '71c1960d-6ced-4281-948a-4369a1e60fdb';

delete from event_person_relation
where true = true;

delete from events
where true = true

/*
select count(*) from people;
insert into people(id, firstname, lastName, age, gender, social_status) values('0afd0f98-9322-11ec-850c-2cfda1aeea94', 'Heather', 'Mckeever', '32', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0afd9391-9322-11ec-bf28-2cfda1aeea94', 'Bernard', 'Grijalva', '93', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0afe7c0c-9322-11ec-931d-2cfda1aeea94', 'Aida', 'Zuhlke', '73', '0', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b02bed8-9322-11ec-8d50-2cfda1aeea94', 'Thomas', 'Talerico', '69', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b057d91-9322-11ec-b339-2cfda1aeea94', 'Barbara', 'Lynch', '4', '0', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b057d92-9322-11ec-bb2e-2cfda1aeea94', 'Elliott', 'Mcmahon', '46', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b09befb-9322-11ec-a9cf-2cfda1aeea94', 'Sharice', 'Benitez', '79', '0', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b0a82fc-9322-11ec-a65a-2cfda1aeea94', 'Marion', 'Coker', '5', '1', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b0aa9f6-9322-11ec-b99d-2cfda1aeea94', 'Celia', 'Smith', '48', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b0ad0de-9322-11ec-9775-2cfda1aeea94', 'Gary', 'Gallaher', '92', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b0b45e0-9322-11ec-a849-2cfda1aeea94', 'Donna', 'Deanda', '28', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b0be193-9322-11ec-b26e-2cfda1aeea94', 'Peter', 'Shaefer', '25', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b0f1288-9322-11ec-bb0a-2cfda1aeea94', 'Susanne', 'Wilson', '51', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b0f397f-9322-11ec-8b4b-2cfda1aeea94', 'William', 'Lacombe', '95', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b0ffd3f-9322-11ec-bb18-2cfda1aeea94', 'Sally', 'Hawthorne', '31', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b104b28-9322-11ec-b6a4-2cfda1aeea94', 'Thomas', 'Smith', '97', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b104b29-9322-11ec-b43d-2cfda1aeea94', 'Virginia', 'Turner', '29', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b104b2a-9322-11ec-95f8-2cfda1aeea94', 'Roger', 'Acevedo', '3', '1', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b10721b-9322-11ec-b794-2cfda1aeea94', 'Maria', 'Pennington', '54', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b109819-9322-11ec-b991-2cfda1aeea94', 'John', 'Jack', '40', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b10c0b6-9322-11ec-a0b0-2cfda1aeea94', 'Nell', 'Gonzalez', '79', '0', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b10e7a3-9322-11ec-88c6-2cfda1aeea94', 'Devon', 'Newsome', '25', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b110ea8-9322-11ec-b019-2cfda1aeea94', 'Tammy', 'Perales', '92', '0', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b11f872-9322-11ec-9812-2cfda1aeea94', 'Mark', 'Hays', '91', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b121f63-9322-11ec-9099-2cfda1aeea94', 'Betty', 'Rennie', '47', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b13089c-9322-11ec-82fc-2cfda1aeea94', 'Gary', 'Davison', '25', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b132f9b-9322-11ec-bca9-2cfda1aeea94', 'Judith', 'Ecklund', '46', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b14404e-9322-11ec-899e-2cfda1aeea94', 'Richard', 'Yancey', '44', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b148e36-9322-11ec-9188-2cfda1aeea94', 'Kathleen', 'Stevenson', '16', '0', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b148e37-9322-11ec-a480-2cfda1aeea94', 'Charles', 'Delvalle', '80', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b14dc23-9322-11ec-9337-2cfda1aeea94', 'Caroline', 'Behr', '68', '0', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b159ee8-9322-11ec-89f7-2cfda1aeea94', 'Raymond', 'Holland', '28', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b159ee9-9322-11ec-8877-2cfda1aeea94', 'Edna', 'Brown', '49', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b15c5df-9322-11ec-aabb-2cfda1aeea94', 'William', 'Sharp', '37', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b15c5e0-9322-11ec-a27e-2cfda1aeea94', 'Pearl', 'Berson', '20', '0', '2');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b1881f7-9322-11ec-a837-2cfda1aeea94', 'Joseph', 'Mccallum', '73', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b18cfde-9322-11ec-992c-2cfda1aeea94', 'Melissa', 'Clark', '62', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b18cfdf-9322-11ec-bcb4-2cfda1aeea94', 'Timothy', 'Lawson', '83', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b18f6d6-9322-11ec-9a83-2cfda1aeea94', 'Rachael', 'Ratledge', '33', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b1b1968-9322-11ec-aa88-2cfda1aeea94', 'George', 'Juarez', '53', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b1b1969-9322-11ec-a4b0-2cfda1aeea94', 'Leslie', 'Wells', '37', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b1b406b-9322-11ec-b6d4-2cfda1aeea94', 'Joseph', 'Vasquez', '4', '1', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b1b406c-9322-11ec-933a-2cfda1aeea94', 'Ellen', 'King', '50', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b1b406d-9322-11ec-ae06-2cfda1aeea94', 'Ahmed', 'Nelson', '14', '1', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b1b6753-9322-11ec-aa2b-2cfda1aeea94', 'Leah', 'Leal', '31', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b1b8da8-9322-11ec-9aab-2cfda1aeea94', 'Scott', 'Vario', '6', '1', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b1ff6de-9322-11ec-a68c-2cfda1aeea94', 'Brooke', 'Wilkerson', '10', '0', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b201dd9-9322-11ec-915c-2cfda1aeea94', 'Carl', 'Nelson', '23', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b204600-9322-11ec-bbd0-2cfda1aeea94', 'Jackie', 'Mondor', '34', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b21f162-9322-11ec-a4d1-2cfda1aeea94', 'Thomas', 'Murphy', '74', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b21f163-9322-11ec-9597-2cfda1aeea94', 'Lesli', 'Churchill', '100', '0', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b228d2e-9322-11ec-b125-2cfda1aeea94', 'William', 'Eubanks', '83', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b22b58a-9322-11ec-87bb-2cfda1aeea94', 'Colleen', 'Gaucin', '35', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b29185e-9322-11ec-bda2-2cfda1aeea94', 'Archie', 'Quinney', '78', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b2b12ce-9322-11ec-a374-2cfda1aeea94', 'Dianne', 'Rohn', '30', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b2cbf5b-9322-11ec-b45e-2cfda1aeea94', 'Robert', 'Isaacs', '59', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b2d0eb7-9322-11ec-83d0-2cfda1aeea94', 'Yong', 'Palmer', '45', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b2d35a7-9322-11ec-9900-2cfda1aeea94', 'Anthony', 'Wheeler', '39', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b2d5b5d-9322-11ec-82ed-2cfda1aeea94', 'Patricia', 'Brown', '1', '0', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b2d5b5e-9322-11ec-adcd-2cfda1aeea94', 'James', 'Certain', '44', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b30db8a-9322-11ec-adab-2cfda1aeea94', 'Lucia', 'Deason', '100', '0', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b319f15-9322-11ec-b8aa-2cfda1aeea94', 'Travis', 'Phillips', '95', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b31c633-9322-11ec-b851-2cfda1aeea94', 'Heather', 'Schofield', '91', '0', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b3212ed-9322-11ec-8d57-2cfda1aeea94', 'James', 'Vaughn', '100', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b3239df-9322-11ec-a7e3-2cfda1aeea94', 'Ying', 'Mallard', '19', '0', '2');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b32fdbc-9322-11ec-9870-2cfda1aeea94', 'Robert', 'Garcia', '42', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b32fdbd-9322-11ec-8dfc-2cfda1aeea94', 'Sharon', 'Miller', '7', '0', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b32fdbe-9322-11ec-b524-2cfda1aeea94', 'James', 'Shaw', '13', '1', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b3324a4-9322-11ec-8409-2cfda1aeea94', 'Myra', 'West', '27', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b3324a5-9322-11ec-a54e-2cfda1aeea94', 'Herbert', 'Corbridge', '29', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b362fe9-9322-11ec-93b8-2cfda1aeea94', 'Julia', 'Kilmer', '40', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b36cbb6-9322-11ec-bbf2-2cfda1aeea94', 'Pierre', 'Mccormick', '51', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b36f195-9322-11ec-83d6-2cfda1aeea94', 'Dorothy', 'Moreno', '64', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b37193b-9322-11ec-8dc2-2cfda1aeea94', 'Rodney', 'Wofford', '60', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b378d6d-9322-11ec-b116-2cfda1aeea94', 'Maribel', 'Uy', '76', '0', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b393b61-9322-11ec-acec-2cfda1aeea94', 'Eric', 'Mashaw', '67', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b3e8d87-9322-11ec-bdf8-2cfda1aeea94', 'Tracy', 'Naranjo', '65', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b3f2954-9322-11ec-83b8-2cfda1aeea94', 'Kenneth', 'Kelly', '3', '1', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b3f2955-9322-11ec-9f2c-2cfda1aeea94', 'Heather', 'Macklin', '14', '0', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b3f9f8e-9322-11ec-ac08-2cfda1aeea94', 'David', 'Garcia', '13', '1', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b3f9f8f-9322-11ec-a346-2cfda1aeea94', 'Susan', 'Headrick', '67', '0', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b401414-9322-11ec-8e3e-2cfda1aeea94', 'Kevin', 'Boyes', '96', '1', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b414abe-9322-11ec-a039-2cfda1aeea94', 'Minnie', 'Lockett', '16', '0', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b4198b2-9322-11ec-936d-2cfda1aeea94', 'Myron', 'Headrick', '48', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b420d84-9322-11ec-8228-2cfda1aeea94', 'Donna', 'Moore', '68', '0', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b420d85-9322-11ec-9639-2cfda1aeea94', 'Lance', 'Dickerson', '11', '1', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b42347b-9322-11ec-b193-2cfda1aeea94', 'Lilia', 'Robinson', '97', '0', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b425b6f-9322-11ec-9bb1-2cfda1aeea94', 'Gerald', 'Rogers', '9', '1', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b425b70-9322-11ec-a8d3-2cfda1aeea94', 'Sheryl', 'Barr', '46', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b4282e5-9322-11ec-91a7-2cfda1aeea94', 'William', 'Beard', '10', '1', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b42a95d-9322-11ec-bcb9-2cfda1aeea94', 'Shanice', 'Cotter', '93', '0', '1');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b43452f-9322-11ec-9237-2cfda1aeea94', 'Aaron', 'Williams', '18', '1', '2');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b436c37-9322-11ec-99e3-2cfda1aeea94', 'Dora', 'Rich', '2', '0', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b4394a8-9322-11ec-85cb-2cfda1aeea94', 'Santiago', 'Sewell', '18', '1', '2');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b43e25d-9322-11ec-9f44-2cfda1aeea94', 'Kayla', 'Lilly', '57', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b440905-9322-11ec-8325-2cfda1aeea94', 'James', 'Acton', '52', '1', '0');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b44cc2a-9322-11ec-a232-2cfda1aeea94', 'Kim', 'Matthews', '5', '0', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b44cc2b-9322-11ec-8fe1-2cfda1aeea94', 'Jessie', 'Russ', '1', '1', '3');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b4518b2-9322-11ec-ab62-2cfda1aeea94', 'Natasha', 'Madsen', '64', '0', '4');
insert into people(id, firstname, lastName, age, gender, social_status) values('0b45681a-9322-11ec-aa10-2cfda1aeea94', 'Charles', 'Mullins', '82', '1', '1');
insert into locations(id, latitude, longitude, city, country)
values('a3eaa615-9326-11ec-bd5b-2cfda1aeea94', 46.770439, 23.591423, 'Cluj-Napoca', 'Romania');
insert into locations(id, latitude, longitude, city, country)
values('a3eacd0a-9326-11ec-835a-2cfda1aeea94', 46.568825, 26.916025, 'Bacau', 'Romania');
insert into locations(id, latitude, longitude, city, country)
values('a3eacd0b-9326-11ec-ba9f-2cfda1aeea94', 47.158455, 27.601442, 'Iasi', 'Romania');
insert into locations(id, latitude, longitude, city, country)
values('a3eacd0c-9326-11ec-a6f9-2cfda1aeea94', 44.179249, 28.649940, 'Constanta', 'Romania');
insert into locations(id, latitude, longitude, city, country)
values('a3eacd0d-9326-11ec-bc8f-2cfda1aeea94', 45.760696, 21.226788, 'Timisoara', 'Romania');
insert into locations(id, latitude, longitude, city, country)
values('a3eacd0e-9326-11ec-af45-2cfda1aeea94', 47.790001, 22.889999, 'Satu Mare', 'Romania');
insert into locations(id, latitude, longitude, city, country)
values('a3eacd0f-9326-11ec-97c7-2cfda1aeea94', 45.474998, 25.251944, 'Sinaia', 'Romania');
insert into locations(id, latitude, longitude, city, country)
values('a3eacd10-9326-11ec-aefd-2cfda1aeea94', 44.563889, 27.366112, 'Slobozia', 'Romania');
insert into locations(id, latitude, longitude, city, country)
values('a3eacd11-9326-11ec-aabf-2cfda1aeea94', 44.940918, 26.021101, 'Ploiesti', 'Romania');
insert into locations(id, latitude, longitude, city, country)
values('a3eacd12-9326-11ec-a896-2cfda1aeea94', 45.657974, 25.601198, 'Ploiesti', 'Romania');*/

/*delete from events where true = true;*/
/*insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b0e477-9411-11ec-b146-2cfda1aeea94', 'CLOxeJjJ', 'a3eacd11-9326-11ec-aabf-2cfda1aeea94', '3', '2', '0', '2022-10-13 17:54:00', '2', '239');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b18cdc-9411-11ec-b2fd-2cfda1aeea94', 'uhoponzX', 'a3eacd11-9326-11ec-aabf-2cfda1aeea94', '0', '2', '1', '2022-12-09 20:21:00', '0', '580');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b18cdd-9411-11ec-a113-2cfda1aeea94', 'fxZNzqIh', 'a3eacd10-9326-11ec-aefd-2cfda1aeea94', '1', '2', '1', '2022-10-16 10:39:00', '3', '605');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b18cde-9411-11ec-b386-2cfda1aeea94', 'RHNjTVrl', 'a3eacd10-9326-11ec-aefd-2cfda1aeea94', '0', '2', '0', '2022-12-28 22:19:00', '1', '278');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b18cdf-9411-11ec-a78e-2cfda1aeea94', 'HeHHnOFG', 'a3eacd0f-9326-11ec-97c7-2cfda1aeea94', '5', '2', '1', '2022-11-14 11:44:00', '3', '698');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b18ce0-9411-11ec-963c-2cfda1aeea94', 'KXMWJZyj', 'a3eacd0f-9326-11ec-97c7-2cfda1aeea94', '9', '2', '0', '2022-11-15 12:24:00', '3', '247');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b18ce1-9411-11ec-a694-2cfda1aeea94', 'nruXeuac', 'a3eacd0e-9326-11ec-af45-2cfda1aeea94', '4', '2', '1', '2022-12-15 10:38:00', '2', '202');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b18ce2-9411-11ec-af4b-2cfda1aeea94', 'CbVJGCKA', 'a3eacd0e-9326-11ec-af45-2cfda1aeea94', '4', '2', '2', '2022-10-17 18:14:00', '2', '275');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b1b3d0-9411-11ec-bfb3-2cfda1aeea94', 'tDDahSqw', 'a3eacd0d-9326-11ec-bc8f-2cfda1aeea94', '4', '2', '1', '2022-11-13 11:18:00', '2', '527');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b1b3d1-9411-11ec-9911-2cfda1aeea94', 'hyHQSmqX', 'a3eacd0d-9326-11ec-bc8f-2cfda1aeea94', '1', '2', '1', '2022-12-30 10:46:00', '2', '519');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b1b3d2-9411-11ec-b882-2cfda1aeea94', 'UJYaBFRU', 'a3eacd0c-9326-11ec-a6f9-2cfda1aeea94', '1', '2', '1', '2022-12-07 19:54:00', '2', '38');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b1b3d3-9411-11ec-b85e-2cfda1aeea94', 'ntKKtPBI', 'a3eacd0c-9326-11ec-a6f9-2cfda1aeea94', '8', '2', '2', '2022-11-14 12:42:00', '0', '579');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b1b3d4-9411-11ec-8438-2cfda1aeea94', 'NrCLGBRF', 'a3eacd0b-9326-11ec-ba9f-2cfda1aeea94', '2', '2', '2', '2022-12-18 20:55:00', '3', '95');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b1b3d5-9411-11ec-b1fe-2cfda1aeea94', 'jURctjTU', 'a3eacd0b-9326-11ec-ba9f-2cfda1aeea94', '2', '2', '0', '2022-10-26 23:19:00', '0', '593');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b1b3d6-9411-11ec-bbce-2cfda1aeea94', 'pkWHCxXg', 'a3eacd0a-9326-11ec-835a-2cfda1aeea94', '4', '2', '1', '2022-12-03 13:18:00', '2', '213');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b1b3d7-9411-11ec-a986-2cfda1aeea94', 'rkavIZUD', 'a3eacd0a-9326-11ec-835a-2cfda1aeea94', '8', '2', '0', '2022-12-21 16:36:00', '1', '448');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b1b3d8-9411-11ec-a3dd-2cfda1aeea94', 'kgaiczqL', 'a3eaa615-9326-11ec-bd5b-2cfda1aeea94', '2', '2', '2', '2022-10-17 11:48:00', '1', '357');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b35414-9411-11ec-abbe-2cfda1aeea94', 'efVNIjgI', 'a3eaa615-9326-11ec-bd5b-2cfda1aeea94', '1', '2', '0', '2022-10-25 10:36:00', '1', '623');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b35415-9411-11ec-8760-2cfda1aeea94', 'JuXhKyxS', 'a3eacd12-9326-11ec-a896-2cfda1aeea94', '9', '2', '0', '2022-12-02 18:42:00', '1', '45');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('52b35416-9411-11ec-9aa1-2cfda1aeea94', 'YAStMSGt', 'a3eacd12-9326-11ec-a896-2cfda1aeea94', '4', '2', '1', '2022-11-18 15:33:00', '1', '628');

insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d327b3dd-94af-11ec-a289-74e5f91a2678', 'gyXIiSUm', 'a3eacd11-9326-11ec-aabf-2cfda1aeea94', '7', '2', '1', '2022-07-19 16:24:00', '2', '649');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d329126c-94af-11ec-825b-74e5f91a2678', 'uDiOuCLU', 'a3eacd11-9326-11ec-aabf-2cfda1aeea94', '2', '2', '0', '2022-08-06 18:58:00', '2', '747');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d3293955-94af-11ec-8c04-74e5f91a2678', 'wafjWEGB', 'a3eacd10-9326-11ec-aefd-2cfda1aeea94', '10', '2', '1', '2022-07-22 14:52:00', '2', '167');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d3293956-94af-11ec-bc6f-74e5f91a2678', 'QbJIYxfE', 'a3eacd10-9326-11ec-aefd-2cfda1aeea94', '5', '2', '2', '2022-05-27 13:15:00', '1', '181');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d3293957-94af-11ec-9361-74e5f91a2678', 'ZuXEgmin', 'a3eacd0f-9326-11ec-97c7-2cfda1aeea94', '2', '2', '1', '2022-07-29 11:12:00', '2', '665');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d3293958-94af-11ec-917c-74e5f91a2678', 'mywMLlDH', 'a3eacd0f-9326-11ec-97c7-2cfda1aeea94', '9', '2', '0', '2022-06-13 23:50:00', '2', '736');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d3293959-94af-11ec-a24a-74e5f91a2678', 'civUyjOn', 'a3eacd0e-9326-11ec-af45-2cfda1aeea94', '2', '2', '0', '2022-03-02 23:22:00', '1', '319');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d329395a-94af-11ec-b315-74e5f91a2678', 'SoWFxQjj', 'a3eacd0e-9326-11ec-af45-2cfda1aeea94', '2', '2', '1', '2022-09-30 10:40:00', '3', '187');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d329395b-94af-11ec-b0f5-74e5f91a2678', 'tqqlWBXO', 'a3eacd0d-9326-11ec-bc8f-2cfda1aeea94', '2', '2', '2', '2022-04-10 11:42:00', '1', '613');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d329395c-94af-11ec-9a7f-74e5f91a2678', 'YhBycfiB', 'a3eacd0d-9326-11ec-bc8f-2cfda1aeea94', '2', '2', '0', '2022-09-18 15:46:00', '3', '722');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d329395d-94af-11ec-bb99-74e5f91a2678', 'ThbCzJXC', 'a3eacd0c-9326-11ec-a6f9-2cfda1aeea94', '4', '2', '1', '2022-05-11 11:30:00', '1', '455');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d329395e-94af-11ec-acad-74e5f91a2678', 'FmbnWYGR', 'a3eacd0c-9326-11ec-a6f9-2cfda1aeea94', '7', '2', '1', '2022-08-12 13:26:00', '2', '610');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d329395f-94af-11ec-9356-74e5f91a2678', 'OVsPJdgH', 'a3eacd0b-9326-11ec-ba9f-2cfda1aeea94', '0', '2', '0', '2022-05-14 16:41:00', '1', '68');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d3293960-94af-11ec-8851-74e5f91a2678', 'MbdLPlND', 'a3eacd0b-9326-11ec-ba9f-2cfda1aeea94', '7', '2', '0', '2022-08-15 12:58:00', '2', '604');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d329605c-94af-11ec-b340-74e5f91a2678', 'lqDalNMf', 'a3eacd0a-9326-11ec-835a-2cfda1aeea94', '10', '2', '1', '2022-08-04 11:13:00', '2', '136');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d329605d-94af-11ec-bb83-74e5f91a2678', 'SXMuiVsF', 'a3eacd0a-9326-11ec-835a-2cfda1aeea94', '0', '2', '1', '2022-03-17 22:49:00', '1', '633');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d329605e-94af-11ec-b16e-74e5f91a2678', 'rcKbPQcZ', 'a3eaa615-9326-11ec-bd5b-2cfda1aeea94', '1', '2', '0', '2022-09-16 15:49:00', '3', '232');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d32a2330-94af-11ec-954d-74e5f91a2678', 'jABfFgVg', 'a3eaa615-9326-11ec-bd5b-2cfda1aeea94', '0', '2', '1', '2022-06-13 14:15:00', '2', '743');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d32a2331-94af-11ec-931d-74e5f91a2678', 'CFwJqnYc', 'a3eacd12-9326-11ec-a896-2cfda1aeea94', '6', '2', '0', '2022-08-17 15:23:00', '2', '183');
insert into events(id, title, location_id, grade, status, type, starting_time, season, amount_spent) values('d32a2332-94af-11ec-9192-74e5f91a2678', 'EJAYMwwy', 'a3eacd12-9326-11ec-a896-2cfda1aeea94', '6', '2', '2', '2022-07-08 13:23:00', '2', '605');

insert into event_person_relation(id, event_id, person_id) values('c41941dc-9415-11ec-b545-2cfda1aeea94', '52b0e477-9411-11ec-b146-2cfda1aeea94', '0b104b2a-9322-11ec-95f8-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941dd-9415-11ec-9d73-2cfda1aeea94', '52b0e477-9411-11ec-b146-2cfda1aeea94', '0b21f162-9322-11ec-a4d1-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941de-9415-11ec-9752-2cfda1aeea94', '52b0e477-9411-11ec-b146-2cfda1aeea94', '0b3f2954-9322-11ec-83b8-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941df-9415-11ec-81b6-2cfda1aeea94', '52b0e477-9411-11ec-b146-2cfda1aeea94', '0b121f63-9322-11ec-9099-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941e0-9415-11ec-9ab0-2cfda1aeea94', '52b0e477-9411-11ec-b146-2cfda1aeea94', '0b109819-9322-11ec-b991-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941e1-9415-11ec-90bf-2cfda1aeea94', '52b18cdc-9411-11ec-b2fd-2cfda1aeea94', '0b0a82fc-9322-11ec-a65a-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941e2-9415-11ec-a62d-2cfda1aeea94', '52b18cdc-9411-11ec-b2fd-2cfda1aeea94', '0b21f163-9322-11ec-9597-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941e3-9415-11ec-9498-2cfda1aeea94', '52b18cdc-9411-11ec-b2fd-2cfda1aeea94', '0b1b406c-9322-11ec-933a-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941e4-9415-11ec-9fc5-2cfda1aeea94', '52b18cdc-9411-11ec-b2fd-2cfda1aeea94', '0b057d92-9322-11ec-bb2e-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941e5-9415-11ec-bd4f-2cfda1aeea94', '52b18cdc-9411-11ec-b2fd-2cfda1aeea94', '0b29185e-9322-11ec-bda2-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941e6-9415-11ec-bd8d-2cfda1aeea94', '52b18cdd-9411-11ec-a113-2cfda1aeea94', '0b0ffd3f-9322-11ec-bb18-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941e7-9415-11ec-8ac4-2cfda1aeea94', '52b18cdd-9411-11ec-a113-2cfda1aeea94', '0b22b58a-9322-11ec-87bb-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941e8-9415-11ec-868d-2cfda1aeea94', '52b18cdd-9411-11ec-a113-2cfda1aeea94', '0b0ad0de-9322-11ec-9775-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941e9-9415-11ec-957c-2cfda1aeea94', '52b18cdd-9411-11ec-a113-2cfda1aeea94', '0b14404e-9322-11ec-899e-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941ea-9415-11ec-b31a-2cfda1aeea94', '52b18cdd-9411-11ec-a113-2cfda1aeea94', '0b401414-9322-11ec-8e3e-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941eb-9415-11ec-92e1-2cfda1aeea94', '52b18cde-9411-11ec-b386-2cfda1aeea94', '0b42a95d-9322-11ec-bcb9-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941ec-9415-11ec-a78c-2cfda1aeea94', '52b18cde-9411-11ec-b386-2cfda1aeea94', '0b09befb-9322-11ec-a9cf-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941ed-9415-11ec-86e8-2cfda1aeea94', '52b18cde-9411-11ec-b386-2cfda1aeea94', '0b18cfde-9322-11ec-992c-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941ee-9415-11ec-9853-2cfda1aeea94', '52b18cde-9411-11ec-b386-2cfda1aeea94', '0b204600-9322-11ec-bbd0-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941ef-9415-11ec-8e76-2cfda1aeea94', '52b18cde-9411-11ec-b386-2cfda1aeea94', '0afe7c0c-9322-11ec-931d-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41941f0-9415-11ec-abf5-2cfda1aeea94', '52b18cdf-9411-11ec-a78e-2cfda1aeea94', '0b104b29-9322-11ec-b43d-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41968ba-9415-11ec-9019-2cfda1aeea94', '52b18cdf-9411-11ec-a78e-2cfda1aeea94', '0b3f2955-9322-11ec-9f2c-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a316e-9415-11ec-a28a-2cfda1aeea94', '52b18cdf-9411-11ec-a78e-2cfda1aeea94', '0b228d2e-9322-11ec-b125-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a316f-9415-11ec-acb4-2cfda1aeea94', '52b18cdf-9411-11ec-a78e-2cfda1aeea94', '0b15c5e0-9322-11ec-a27e-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3170-9415-11ec-a07c-2cfda1aeea94', '52b18cdf-9411-11ec-a78e-2cfda1aeea94', '0b440905-9322-11ec-8325-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3171-9415-11ec-b6e1-2cfda1aeea94', '52b18ce0-9411-11ec-963c-2cfda1aeea94', '0b420d84-9322-11ec-8228-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3172-9415-11ec-866e-2cfda1aeea94', '52b18ce0-9411-11ec-963c-2cfda1aeea94', '0b3e8d87-9322-11ec-bdf8-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3173-9415-11ec-b6a1-2cfda1aeea94', '52b18ce0-9411-11ec-963c-2cfda1aeea94', '0b110ea8-9322-11ec-b019-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3174-9415-11ec-a5e2-2cfda1aeea94', '52b18ce0-9411-11ec-963c-2cfda1aeea94', '0b43e25d-9322-11ec-9f44-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3175-9415-11ec-be60-2cfda1aeea94', '52b18ce0-9411-11ec-963c-2cfda1aeea94', '0b132f9b-9322-11ec-bca9-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3176-9415-11ec-ab7d-2cfda1aeea94', '52b18ce1-9411-11ec-a694-2cfda1aeea94', '0b45681a-9322-11ec-aa10-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3177-9415-11ec-aac8-2cfda1aeea94', '52b18ce1-9411-11ec-a694-2cfda1aeea94', '0b3f9f8e-9322-11ec-ac08-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3178-9415-11ec-bf42-2cfda1aeea94', '52b18ce1-9411-11ec-a694-2cfda1aeea94', '0afd9391-9322-11ec-bf28-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3179-9415-11ec-aef0-2cfda1aeea94', '52b18ce1-9411-11ec-a694-2cfda1aeea94', '0b18cfdf-9322-11ec-bcb4-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a317a-9415-11ec-9941-2cfda1aeea94', '52b18ce1-9411-11ec-a694-2cfda1aeea94', '0b0f397f-9322-11ec-8b4b-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a317b-9415-11ec-99d8-2cfda1aeea94', '52b18ce2-9411-11ec-af4b-2cfda1aeea94', '0b0f1288-9322-11ec-bb0a-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a317c-9415-11ec-b1ba-2cfda1aeea94', '52b18ce2-9411-11ec-af4b-2cfda1aeea94', '0b159ee9-9322-11ec-8877-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a317d-9415-11ec-8299-2cfda1aeea94', '52b18ce2-9411-11ec-af4b-2cfda1aeea94', '0b4198b2-9322-11ec-936d-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a317e-9415-11ec-9340-2cfda1aeea94', '52b18ce2-9411-11ec-af4b-2cfda1aeea94', '0b4282e5-9322-11ec-91a7-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a317f-9415-11ec-b924-2cfda1aeea94', '52b18ce2-9411-11ec-af4b-2cfda1aeea94', '0b414abe-9322-11ec-a039-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3180-9415-11ec-ab14-2cfda1aeea94', '52b1b3d0-9411-11ec-bfb3-2cfda1aeea94', '0b1b6753-9322-11ec-aa2b-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3181-9415-11ec-b723-2cfda1aeea94', '52b1b3d0-9411-11ec-bfb3-2cfda1aeea94', '0b3f9f8f-9322-11ec-a346-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3182-9415-11ec-a3d3-2cfda1aeea94', '52b1b3d0-9411-11ec-bfb3-2cfda1aeea94', '0b02bed8-9322-11ec-8d50-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3183-9415-11ec-92ed-2cfda1aeea94', '52b1b3d0-9411-11ec-bfb3-2cfda1aeea94', '0b0be193-9322-11ec-b26e-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3184-9415-11ec-953f-2cfda1aeea94', '52b1b3d0-9411-11ec-bfb3-2cfda1aeea94', '0b1b8da8-9322-11ec-9aab-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3185-9415-11ec-ba89-2cfda1aeea94', '52b1b3d1-9411-11ec-9911-2cfda1aeea94', '0b1881f7-9322-11ec-a837-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3186-9415-11ec-8aaf-2cfda1aeea94', '52b1b3d1-9411-11ec-9911-2cfda1aeea94', '0b10e7a3-9322-11ec-88c6-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3187-9415-11ec-b3ad-2cfda1aeea94', '52b1b3d1-9411-11ec-9911-2cfda1aeea94', '0b148e36-9322-11ec-9188-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3188-9415-11ec-81b9-2cfda1aeea94', '52b1b3d1-9411-11ec-9911-2cfda1aeea94', '0b4518b2-9322-11ec-ab62-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a3189-9415-11ec-a8cd-2cfda1aeea94', '52b1b3d1-9411-11ec-9911-2cfda1aeea94', '0b425b6f-9322-11ec-9bb1-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a318a-9415-11ec-a2e4-2cfda1aeea94', '52b1b3d2-9411-11ec-b882-2cfda1aeea94', '0b1b406d-9322-11ec-ae06-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a318b-9415-11ec-9e27-2cfda1aeea94', '52b1b3d2-9411-11ec-b882-2cfda1aeea94', '0b14dc23-9322-11ec-9337-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a318c-9415-11ec-a984-2cfda1aeea94', '52b1b3d2-9411-11ec-b882-2cfda1aeea94', '0b4394a8-9322-11ec-85cb-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a318d-9415-11ec-8f58-2cfda1aeea94', '52b1b3d2-9411-11ec-b882-2cfda1aeea94', '0b44cc2a-9322-11ec-a232-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a318e-9415-11ec-adf2-2cfda1aeea94', '52b1b3d2-9411-11ec-b882-2cfda1aeea94', '0b159ee8-9322-11ec-89f7-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a318f-9415-11ec-8689-2cfda1aeea94', '52b1b3d3-9411-11ec-b85e-2cfda1aeea94', '0b0aa9f6-9322-11ec-b99d-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a564b-9415-11ec-8512-2cfda1aeea94', '52b1b3d3-9411-11ec-b85e-2cfda1aeea94', '0b1b1968-9322-11ec-aa88-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a564c-9415-11ec-8895-2cfda1aeea94', '52b1b3d3-9411-11ec-b85e-2cfda1aeea94', '0b13089c-9322-11ec-82fc-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a564d-9415-11ec-81f7-2cfda1aeea94', '52b1b3d3-9411-11ec-b85e-2cfda1aeea94', '0b18f6d6-9322-11ec-9a83-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a564e-9415-11ec-a59a-2cfda1aeea94', '52b1b3d3-9411-11ec-b85e-2cfda1aeea94', '0b10c0b6-9322-11ec-a0b0-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a564f-9415-11ec-8999-2cfda1aeea94', '52b1b3d4-9411-11ec-8438-2cfda1aeea94', '0b0b45e0-9322-11ec-a849-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a5650-9415-11ec-92db-2cfda1aeea94', '52b1b3d4-9411-11ec-8438-2cfda1aeea94', '0afd0f98-9322-11ec-850c-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a5651-9415-11ec-85f1-2cfda1aeea94', '52b1b3d4-9411-11ec-8438-2cfda1aeea94', '0b104b28-9322-11ec-b6a4-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a5652-9415-11ec-8b00-2cfda1aeea94', '52b1b3d4-9411-11ec-8438-2cfda1aeea94', '0b44cc2b-9322-11ec-8fe1-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a5653-9415-11ec-827e-2cfda1aeea94', '52b1b3d4-9411-11ec-8438-2cfda1aeea94', '0b1b406b-9322-11ec-b6d4-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a5654-9415-11ec-b8c4-2cfda1aeea94', '52b1b3d5-9411-11ec-b1fe-2cfda1aeea94', '0b15c5df-9322-11ec-aabb-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a5655-9415-11ec-91b1-2cfda1aeea94', '52b1b3d5-9411-11ec-b1fe-2cfda1aeea94', '0b1ff6de-9322-11ec-a68c-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a5656-9415-11ec-a8fc-2cfda1aeea94', '52b1b3d5-9411-11ec-b1fe-2cfda1aeea94', '0b201dd9-9322-11ec-915c-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a5657-9415-11ec-a437-2cfda1aeea94', '52b1b3d5-9411-11ec-b1fe-2cfda1aeea94', '0b436c37-9322-11ec-99e3-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a5658-9415-11ec-8b3f-2cfda1aeea94', '52b1b3d5-9411-11ec-b1fe-2cfda1aeea94', '0b43452f-9322-11ec-9237-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a5659-9415-11ec-b04f-2cfda1aeea94', '52b1b3d6-9411-11ec-bbce-2cfda1aeea94', '0b425b70-9322-11ec-a8d3-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a565a-9415-11ec-93f3-2cfda1aeea94', '52b1b3d6-9411-11ec-bbce-2cfda1aeea94', '0b420d85-9322-11ec-9639-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a565b-9415-11ec-bf4a-2cfda1aeea94', '52b1b3d6-9411-11ec-bbce-2cfda1aeea94', '0b11f872-9322-11ec-9812-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a565c-9415-11ec-a1f2-2cfda1aeea94', '52b1b3d6-9411-11ec-bbce-2cfda1aeea94', '0b057d91-9322-11ec-b339-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a565d-9415-11ec-ba3e-2cfda1aeea94', '52b1b3d6-9411-11ec-bbce-2cfda1aeea94', '0b1b1969-9322-11ec-a4b0-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a565e-9415-11ec-b12d-2cfda1aeea94', '52b1b3d7-9411-11ec-a986-2cfda1aeea94', '0b148e37-9322-11ec-a480-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a565f-9415-11ec-aad9-2cfda1aeea94', '52b1b3d7-9411-11ec-a986-2cfda1aeea94', '0b10721b-9322-11ec-b794-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('c41a5660-9415-11ec-89f7-2cfda1aeea94', '52b1b3d7-9411-11ec-a986-2cfda1aeea94', '0b42347b-9322-11ec-b193-2cfda1aeea94');*/

/*insert into event_person_relation(id, event_id, person_id) values('e1178c0c-94b0-11ec-8f96-74e5f91a2678', 'd327b3dd-94af-11ec-a289-74e5f91a2678', '0b43452f-9322-11ec-9237-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c0d-94b0-11ec-9d97-74e5f91a2678', 'd327b3dd-94af-11ec-a289-74e5f91a2678', '0b401414-9322-11ec-8e3e-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c0e-94b0-11ec-b47d-74e5f91a2678', 'd327b3dd-94af-11ec-a289-74e5f91a2678', '0b14404e-9322-11ec-899e-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c0f-94b0-11ec-b361-74e5f91a2678', 'd327b3dd-94af-11ec-a289-74e5f91a2678', '0b132f9b-9322-11ec-bca9-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c10-94b0-11ec-9bc9-74e5f91a2678', 'd327b3dd-94af-11ec-a289-74e5f91a2678', '0b1b406c-9322-11ec-933a-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c11-94b0-11ec-80b1-74e5f91a2678', 'd329126c-94af-11ec-825b-74e5f91a2678', '0b10721b-9322-11ec-b794-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c12-94b0-11ec-af1f-74e5f91a2678', 'd329126c-94af-11ec-825b-74e5f91a2678', '0b44cc2a-9322-11ec-a232-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c13-94b0-11ec-9bb4-74e5f91a2678', 'd329126c-94af-11ec-825b-74e5f91a2678', '0b21f163-9322-11ec-9597-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c14-94b0-11ec-bc5d-74e5f91a2678', 'd329126c-94af-11ec-825b-74e5f91a2678', '0b0be193-9322-11ec-b26e-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c15-94b0-11ec-9f3a-74e5f91a2678', 'd329126c-94af-11ec-825b-74e5f91a2678', '0b10e7a3-9322-11ec-88c6-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c16-94b0-11ec-932d-74e5f91a2678', 'd3293955-94af-11ec-8c04-74e5f91a2678', '0b0aa9f6-9322-11ec-b99d-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c17-94b0-11ec-974b-74e5f91a2678', 'd3293955-94af-11ec-8c04-74e5f91a2678', '0b1b1969-9322-11ec-a4b0-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c18-94b0-11ec-94d8-74e5f91a2678', 'd3293955-94af-11ec-8c04-74e5f91a2678', '0b18f6d6-9322-11ec-9a83-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c19-94b0-11ec-a6e1-74e5f91a2678', 'd3293955-94af-11ec-8c04-74e5f91a2678', '0b425b70-9322-11ec-a8d3-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c1a-94b0-11ec-9303-74e5f91a2678', 'd3293955-94af-11ec-8c04-74e5f91a2678', '0b18cfde-9322-11ec-992c-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c1b-94b0-11ec-b759-74e5f91a2678', 'd3293956-94af-11ec-bc6f-74e5f91a2678', '0b15c5e0-9322-11ec-a27e-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c1c-94b0-11ec-9969-74e5f91a2678', 'd3293956-94af-11ec-bc6f-74e5f91a2678', '0b104b29-9322-11ec-b43d-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c1d-94b0-11ec-8906-74e5f91a2678', 'd3293956-94af-11ec-bc6f-74e5f91a2678', '0b0a82fc-9322-11ec-a65a-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c1e-94b0-11ec-b700-74e5f91a2678', 'd3293956-94af-11ec-bc6f-74e5f91a2678', '0b0f397f-9322-11ec-8b4b-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c1f-94b0-11ec-8fa1-74e5f91a2678', 'd3293956-94af-11ec-bc6f-74e5f91a2678', '0b057d92-9322-11ec-bb2e-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c20-94b0-11ec-9978-74e5f91a2678', 'd3293957-94af-11ec-9361-74e5f91a2678', '0b104b28-9322-11ec-b6a4-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e1178c21-94b0-11ec-ad70-74e5f91a2678', 'd3293957-94af-11ec-9361-74e5f91a2678', '0b1b406b-9322-11ec-b6d4-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad73-94b0-11ec-91c0-74e5f91a2678', 'd3293957-94af-11ec-9361-74e5f91a2678', '0b1b406d-9322-11ec-ae06-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad74-94b0-11ec-bd88-74e5f91a2678', 'd3293957-94af-11ec-9361-74e5f91a2678', '0b0f1288-9322-11ec-bb0a-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad75-94b0-11ec-be1d-74e5f91a2678', 'd3293957-94af-11ec-9361-74e5f91a2678', '0b420d84-9322-11ec-8228-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad76-94b0-11ec-a731-74e5f91a2678', 'd3293958-94af-11ec-917c-74e5f91a2678', '0b45681a-9322-11ec-aa10-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad77-94b0-11ec-84a9-74e5f91a2678', 'd3293958-94af-11ec-917c-74e5f91a2678', '0b10c0b6-9322-11ec-a0b0-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad78-94b0-11ec-86e4-74e5f91a2678', 'd3293958-94af-11ec-917c-74e5f91a2678', '0b13089c-9322-11ec-82fc-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad79-94b0-11ec-bb9c-74e5f91a2678', 'd3293958-94af-11ec-917c-74e5f91a2678', '0b4518b2-9322-11ec-ab62-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad7a-94b0-11ec-97ea-74e5f91a2678', 'd3293958-94af-11ec-917c-74e5f91a2678', '0b3f2954-9322-11ec-83b8-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad7b-94b0-11ec-a6ef-74e5f91a2678', 'd3293959-94af-11ec-a24a-74e5f91a2678', '0b201dd9-9322-11ec-915c-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad7c-94b0-11ec-9127-74e5f91a2678', 'd3293959-94af-11ec-a24a-74e5f91a2678', '0b3f9f8f-9322-11ec-a346-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad7d-94b0-11ec-bbcf-74e5f91a2678', 'd3293959-94af-11ec-a24a-74e5f91a2678', '0b204600-9322-11ec-bbd0-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad7e-94b0-11ec-83eb-74e5f91a2678', 'd3293959-94af-11ec-a24a-74e5f91a2678', '0b1b1968-9322-11ec-aa88-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad7f-94b0-11ec-8187-74e5f91a2678', 'd3293959-94af-11ec-a24a-74e5f91a2678', '0b121f63-9322-11ec-9099-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad80-94b0-11ec-a751-74e5f91a2678', 'd329395a-94af-11ec-b315-74e5f91a2678', '0b1b6753-9322-11ec-aa2b-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad81-94b0-11ec-992c-74e5f91a2678', 'd329395a-94af-11ec-b315-74e5f91a2678', '0b440905-9322-11ec-8325-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad82-94b0-11ec-b05d-74e5f91a2678', 'd329395a-94af-11ec-b315-74e5f91a2678', '0b228d2e-9322-11ec-b125-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad83-94b0-11ec-a907-74e5f91a2678', 'd329395a-94af-11ec-b315-74e5f91a2678', '0b1881f7-9322-11ec-a837-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad84-94b0-11ec-a7e5-74e5f91a2678', 'd329395a-94af-11ec-b315-74e5f91a2678', '0b148e36-9322-11ec-9188-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad85-94b0-11ec-82de-74e5f91a2678', 'd329395b-94af-11ec-b0f5-74e5f91a2678', '0b0ad0de-9322-11ec-9775-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad86-94b0-11ec-ada6-74e5f91a2678', 'd329395b-94af-11ec-b0f5-74e5f91a2678', '0b4282e5-9322-11ec-91a7-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad87-94b0-11ec-a7ee-74e5f91a2678', 'd329395b-94af-11ec-b0f5-74e5f91a2678', '0b29185e-9322-11ec-bda2-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad88-94b0-11ec-b94c-74e5f91a2678', 'd329395b-94af-11ec-b0f5-74e5f91a2678', '0b0b45e0-9322-11ec-a849-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad89-94b0-11ec-b891-74e5f91a2678', 'd329395b-94af-11ec-b0f5-74e5f91a2678', '0b4198b2-9322-11ec-936d-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad8a-94b0-11ec-b080-74e5f91a2678', 'd329395c-94af-11ec-9a7f-74e5f91a2678', '0b1ff6de-9322-11ec-a68c-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad8b-94b0-11ec-a8bb-74e5f91a2678', 'd329395c-94af-11ec-9a7f-74e5f91a2678', '0b21f162-9322-11ec-a4d1-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad8c-94b0-11ec-8b50-74e5f91a2678', 'd329395c-94af-11ec-9a7f-74e5f91a2678', '0b0ffd3f-9322-11ec-bb18-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad8d-94b0-11ec-ae78-74e5f91a2678', 'd329395c-94af-11ec-9a7f-74e5f91a2678', '0afd0f98-9322-11ec-850c-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad8e-94b0-11ec-b701-74e5f91a2678', 'd329395c-94af-11ec-9a7f-74e5f91a2678', '0b057d91-9322-11ec-b339-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad8f-94b0-11ec-8482-74e5f91a2678', 'd329395d-94af-11ec-bb99-74e5f91a2678', '0b22b58a-9322-11ec-87bb-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad90-94b0-11ec-be30-74e5f91a2678', 'd329395d-94af-11ec-bb99-74e5f91a2678', '0b43e25d-9322-11ec-9f44-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad91-94b0-11ec-8ace-74e5f91a2678', 'd329395d-94af-11ec-bb99-74e5f91a2678', '0b420d85-9322-11ec-9639-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad92-94b0-11ec-b461-74e5f91a2678', 'd329395d-94af-11ec-bb99-74e5f91a2678', '0b4394a8-9322-11ec-85cb-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119ad93-94b0-11ec-9f1b-74e5f91a2678', 'd329395d-94af-11ec-bb99-74e5f91a2678', '0b14dc23-9322-11ec-9337-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d46c-94b0-11ec-bc9b-74e5f91a2678', 'd329395e-94af-11ec-acad-74e5f91a2678', '0b110ea8-9322-11ec-b019-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d46d-94b0-11ec-b2cf-74e5f91a2678', 'd329395e-94af-11ec-acad-74e5f91a2678', '0b44cc2b-9322-11ec-8fe1-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d46e-94b0-11ec-97c4-74e5f91a2678', 'd329395e-94af-11ec-acad-74e5f91a2678', '0b414abe-9322-11ec-a039-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d46f-94b0-11ec-97b7-74e5f91a2678', 'd329395e-94af-11ec-acad-74e5f91a2678', '0b109819-9322-11ec-b991-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d470-94b0-11ec-89a3-74e5f91a2678', 'd329395e-94af-11ec-acad-74e5f91a2678', '0b436c37-9322-11ec-99e3-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d471-94b0-11ec-abd5-74e5f91a2678', 'd329395f-94af-11ec-9356-74e5f91a2678', '0b42a95d-9322-11ec-bcb9-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d472-94b0-11ec-a5a1-74e5f91a2678', 'd329395f-94af-11ec-9356-74e5f91a2678', '0b1b8da8-9322-11ec-9aab-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d473-94b0-11ec-b211-74e5f91a2678', 'd329395f-94af-11ec-9356-74e5f91a2678', '0b3f2955-9322-11ec-9f2c-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d474-94b0-11ec-a725-74e5f91a2678', 'd329395f-94af-11ec-9356-74e5f91a2678', '0b09befb-9322-11ec-a9cf-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d475-94b0-11ec-8da9-74e5f91a2678', 'd329395f-94af-11ec-9356-74e5f91a2678', '0afe7c0c-9322-11ec-931d-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d476-94b0-11ec-aec2-74e5f91a2678', 'd3293960-94af-11ec-8851-74e5f91a2678', '0b159ee8-9322-11ec-89f7-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d477-94b0-11ec-bfb1-74e5f91a2678', 'd3293960-94af-11ec-8851-74e5f91a2678', '0afd9391-9322-11ec-bf28-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d478-94b0-11ec-afdc-74e5f91a2678', 'd3293960-94af-11ec-8851-74e5f91a2678', '0b42347b-9322-11ec-b193-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d479-94b0-11ec-969d-74e5f91a2678', 'd3293960-94af-11ec-8851-74e5f91a2678', '0b159ee9-9322-11ec-8877-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d47a-94b0-11ec-999d-74e5f91a2678', 'd3293960-94af-11ec-8851-74e5f91a2678', '0b3f9f8e-9322-11ec-ac08-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d47b-94b0-11ec-997d-74e5f91a2678', 'd329605c-94af-11ec-b340-74e5f91a2678', '0b148e37-9322-11ec-a480-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d47c-94b0-11ec-8102-74e5f91a2678', 'd329605c-94af-11ec-b340-74e5f91a2678', '0b18cfdf-9322-11ec-bcb4-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119d47d-94b0-11ec-9e55-74e5f91a2678', 'd329605c-94af-11ec-b340-74e5f91a2678', '0b15c5df-9322-11ec-aabb-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119fb71-94b0-11ec-b4dc-74e5f91a2678', 'd329605c-94af-11ec-b340-74e5f91a2678', '0b3e8d87-9322-11ec-bdf8-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119fb72-94b0-11ec-8eb4-74e5f91a2678', 'd329605c-94af-11ec-b340-74e5f91a2678', '0b11f872-9322-11ec-9812-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119fb73-94b0-11ec-8646-74e5f91a2678', 'd329605d-94af-11ec-bb83-74e5f91a2678', '0b425b6f-9322-11ec-9bb1-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119fb74-94b0-11ec-85e6-74e5f91a2678', 'd329605d-94af-11ec-bb83-74e5f91a2678', '0b02bed8-9322-11ec-8d50-2cfda1aeea94');
insert into event_person_relation(id, event_id, person_id) values('e119fb75-94b0-11ec-be3b-74e5f91a2678', 'd329605d-94af-11ec-bb83-74e5f91a2678', '0b104b2a-9322-11ec-95f8-2cfda1aeea94');*/

/*delete from event_person_relation
where event_id = (select id from events
    where title = 'Coffee Time');
delete from events
where title = 'Coffee Time'*/

select count(*) from events;

