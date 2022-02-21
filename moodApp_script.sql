create database MoodApp;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

create table locations (
	id uuid PRIMARY KEY not null,
	latitude double precision not null,
	longitude double precision not null,
	city varchar(500) not null,
	country varchar(500) not null
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

/*
drop table event_person_relation;
drop table people;
drop table events;
drop table locations;

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
