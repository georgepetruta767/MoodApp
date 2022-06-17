create database MoodApp;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

create table locations (
	id uuid PRIMARY KEY not null,
	latitude double precision not null,
	longitude double precision not null,
	city varchar(500) not null,
	country varchar(500) not null
);

create table Context(id uuid primary key not null);
/*    aspNetUserId text constraint FK_AspNetUsers_AspNetUser_id references "AspNetUsers"("Id") not null
*/

create table events (
	id uuid PRIMARY KEY NOT NULL,
	title varchar(500),
	location_id uuid constraint FK_locations_location_id references locations(id),
	grade int,
	status int not null,
	type int not null,
	starting_time timestamptz not null,
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

alter table Context
add aspNetUserId text constraint FK_AspNetUsers_AspNetUser_id references "AspNetUsers"("Id") not null;


drop table event_person_relation;
drop table people;
drop table events;
drop table locations;
drop table Context;


SELECT CONCAT(ppl.firstname, ' ', ppl.lastname), AVG(evt.grade)
    FROM (select * from events
         WHERE context_id = (select id from context where aspnetuserid = 'f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0' AND status = 2)) as evt
    /*INNER JOIN people ppl on evt.context_id = ppl.context_id*/
    GROUP BY CONCAT(ppl.firstname, ' ', ppl.lastname)
    ORDER BY AVG(evt.grade) DESC
    LIMIT 3;

select * from people P
where P.context_id = (select id from context where Context.aspNetUserId =  '6f69901a-a348-4dc7-b4d1-3a65a9a31853');

select R.person_id from event_person_relation R
where R.event_id in (select E.id from events E where context_id = (select id from context where aspnetuserid = '6f69901a-a348-4dc7-b4d1-3a65a9a31853') AND status = 2));


select X.person_id, AVG(X.grade) from
(select * from event_person_relation inner join events e on e.id = event_person_relation.event_id where e.context_id = (select id from context where aspnetuserid = '6f69901a-a348-4dc7-b4d1-3a65a9a31853')) as X
group by X.person_id;

select CONCAT(X.firstName, ' ', X.lastName), AVG(X.grade) from
(select * from (select a.firstname, a.lastName, r.event_id from people a inner join event_person_relation r on a.id = r.person_id) as lNei inner join events e on e.id = lNei.event_id where e.context_id = (select id from context where aspnetuserid = 'f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0')) as X
group by CONCAT(X.firstName, ' ', X.lastName)
order by AVG(x.grade) DESC
LIMIT 10;


delete from event_person_relation R
where R.person_id in (select person_id from people where context_id in (select id from context where Context.aspNetUserId != 'f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0'));


select a.firstname, a.lastName, r.event_id from people a inner join event_person_relation r on a.id = r.person_id) as lNei
    inner join events e on e.id = lNei.event_id where e.context_id = (select id from context where aspnetuserid = 'f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0')


delete from "AspNetUsers" E
where E."Id" != 'f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0'

WITH cte_grade_over_date AS (
                SELECT EXTRACT(YEAR FROM starting_time) AS year, grade
                FROM events E
                WHERE E.context_id = (select id from context where aspnetuserid = '535588be-9379-4592-9d2a-c3f5023741a9' AND E.status = 2))
            SELECT year, AVG(grade)
            FROM cte_grade_over_date
            GROUP BY year
            ORDER BY year;

SELECT city, longitude, latitude, AVG(grade)
        FROM events e
        INNER JOIN locations l
        ON e.location_id = l.id
        WHERE E.context_id = (select id from context where aspnetuserid = '535588be-9379-4592-9d2a-c3f5023741a9' AND E.status = 2)
        GROUP BY city, longitude, latitude;


/* WITH cte_grade_over_date AS (
        SELECT EXTRACT(MONTH FROM starting_time) AS month, EXTRACT(YEAR FROM starting_time) AS year, grade
        FROM events E
        WHERE E.context_id = (select id from context where aspnetuserid = '{user_id}' AND E.status = 2)
    )
    SELECT month, year, AVG(grade)
    FROM cte_grade_over_date
    GROUP BY month, year
    ORDER BY month, year;

SELECT CONCAT(ppl.firstname, ' ', ppl.lastname), AVG(evt.grade)
        FROM (select * from events
        WHERE context_id = (select id from context where aspnetuserid = 'f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0' AND status = 2)) as evt
        INNER JOIN people ppl on evt.context_id = ppl.context_id
        GROUP BY CONCAT(ppl.firstname, ' ', ppl.lastname)
        ORDER BY AVG(evt.grade) DESC
        LIMIT 5;

WITH cte_grade_over_date AS (
        SELECT EXTRACT(MONTH FROM starting_time) AS month, EXTRACT(YEAR FROM starting_time) AS year, grade
        FROM events E
        WHERE E.context_id = (select id from context where aspnetuserid = '6f69901a-a348-4dc7-b4d1-3a65a9a31853' AND E.status = 2)
    )
    SELECT month, year, AVG(grade)
    FROM cte_grade_over_date
    GROUP BY month, year
    ORDER BY month, year;

SELECT *
        FROM events E
        WHERE E.context_id = (select id from context where aspnetuserid = '6f69901a-a348-4dc7-b4d1-3a65a9a31853' AND E.status = 2);

select * from events E
where E.context_id = (select id from context C where C.aspnetuserid = '1971eefe-9fb9-4683-93fa-292b18c41608');

WITH cte_grade_over_date AS (
    SELECT EXTRACT(MONTH FROM starting_time) AS month, EXTRACT(YEAR FROM starting_time) AS year, grade
    FROM events E
    WHERE E.context_id = (select id from context where aspnetuserid = 'f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0' AND E.status = 2)
)
SELECT month, year, AVG(grade)
FROM cte_grade_over_date
GROUP BY month, year
ORDER BY month, year;


--year
WITH cte_grade_over_date AS (
    SELECT EXTRACT(YEAR FROM starting_time) AS year, grade
    FROM events E
    WHERE E.context_id = (select id from context where aspnetuserid = 'f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0' AND E.status = 2)
)
SELECT year, AVG(grade)
FROM cte_grade_over_date
GROUP BY year
ORDER BY year;


--month + year 2021
WITH cte_grade_over_date AS (
    SELECT EXTRACT(MONTH FROM starting_time) AS month, grade
    FROM events E
    WHERE (E.context_id = (select id from context where aspnetuserid = 'f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0' AND E.status = 2) and EXTRACT(YEAR FROM starting_time) = 2021)
)
SELECT month, AVG(grade)
FROM cte_grade_over_date
GROUP BY month
ORDER BY month;

--day + month 7 + year 2021
WITH cte_grade_over_date AS (
    SELECT EXTRACT(DAY FROM starting_time) as day, grade
    FROM events E
    WHERE (E.context_id = (select id from context where aspnetuserid = 'f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0' AND E.status = 2) and EXTRACT(MONTH FROM starting_time) = 7 and EXTRACT(YEAR FROM starting_time) = 2021)
)
SELECT day, AVG(grade)
FROM cte_grade_over_date
GROUP BY day
ORDER BY day;

SELECT amount_spent, grade FROM events E
            WHERE (E.context_id = (select id from context where aspnetuserid = '6f69901a-a348-4dc7-b4d1-3a65a9a31853') AND E.status = 2 and E.amount_spent is not null)

--hour + day = 4 month = 6 year = 2022
WITH cte_grade_over_date AS (
    SELECT EXTRACT(HOUR FROM starting_time) AS hour, EXTRACT(YEAR FROM starting_time) AS year, grade
    FROM events E
    WHERE (E.context_id = (select id from context where aspnetuserid = '6f69901a-a348-4dc7-b4d1-3a65a9a31853' AND E.status = 2) and
           EXTRACT(MONTH FROM starting_time) = 6 and EXTRACT(YEAR FROM starting_time) = 2022 and EXTRACT(DAY FROM starting_time) = 4)
)
SELECT hour, AVG(grade)
FROM cte_grade_over_date
GROUP BY hour
ORDER BY hour;*/

/*SELECT amount_spent, AVG(grade) FROM events
WHERE context_id = (select id from context where aspnetuserid = 'f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0')
GROUP BY amount_spent;

SELECT amount_spent, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY grade) FROM events
WHERE context_id = (select id from context where aspnetuserid = 'f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0')
GROUP BY amount_spent;

delete from event_person_relation
    where 1 = 1;



delete from People E
where E.context_id in (select C.id from Context C
where C.aspnetuserid in (select U."Id" from "AspNetUsers" U where U."UserName" in ('EdiTobicu', 'RobertCrisan', 'PetrutaGheorghe', 'GheorghePetruta')));

delete from context C
where C.aspnetuserid in (select U."Id" from "AspNetUsers" U where U."UserName" in ('RobertCrisan', 'PetrutaGheorghe', 'GheorghePetruta'));

SELECT amount_spent, grade FROM events E
WHERE E.context_id = (select id from context where aspnetuserid = 'f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0') AND E.status = 2;


select amount_spent, grade from events E
where E.status = 2 and context_id = (select id from context C where C.aspnetuserid = (select U."Id" from "AspNetUsers" U where U."UserName" = 'GeorgePetruta'));


delete from "AspNetUsers" U
where U."UserName" in ('RobertCrisan', 'PetrutaGheorghe', 'GheorghePetruta');

update events
set starting_time = starting_time - interval '1 year';

update events
set ending_time = ending_time - interval '1 year';


insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('744d5b74-cbb7-11ec-940f-2cfda1aeea94', 'IWerjrJY', 'a3eacd12-9326-11ec-a896-2cfda1aeea94', '6', '2', '0', '2022-11-22 20:15:00', '2022-11-23 01:23:00', '2', '78', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('744fbd07-cbb7-11ec-9c0b-2cfda1aeea94', 'SGjFuwWd', 'a3eacd12-9326-11ec-a896-2cfda1aeea94', '4', '2', '2', '2022-05-27 11:44:00', '2022-05-27 14:38:00', '0', '8', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('744fbd08-cbb7-11ec-a1bc-2cfda1aeea94', 'GLvVvJfj', 'a3eacd11-9326-11ec-aabf-2cfda1aeea94', '2', '2', '2', '2022-12-23 16:14:00', '2022-12-23 22:13:00', '2', '7', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('744fbd09-cbb7-11ec-8800-2cfda1aeea94', 'anitriqY', 'a3eacd11-9326-11ec-aabf-2cfda1aeea94', '3', '2', '1', '2022-03-15 16:34:00', '2022-03-15 21:02:00', '0', '204', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('744fbd0a-cbb7-11ec-a7fe-2cfda1aeea94', 'YeXkiBCN', 'a3eacd10-9326-11ec-aefd-2cfda1aeea94', '2', '2', '0', '2022-01-22 13:17:00', '2022-01-22 16:15:00', '0', '21', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('744fbd0b-cbb7-11ec-9ed0-2cfda1aeea94', 'vbaprjhM', 'a3eacd10-9326-11ec-aefd-2cfda1aeea94', '6', '2', '2', '2022-04-17 13:35:00', '2022-04-17 15:18:00', '3', '97', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('744fbd0c-cbb7-11ec-93ac-2cfda1aeea94', 'HwMtZlYF', 'a3eacd0f-9326-11ec-97c7-2cfda1aeea94', '3', '2', '0', '2022-01-19 11:40:00', '2022-01-19 17:13:00', '1', '206', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('744fbd0d-cbb7-11ec-be97-2cfda1aeea94', 'GNvkGKiB', 'a3eacd0f-9326-11ec-97c7-2cfda1aeea94', '8', '2', '1', '2022-11-02 18:50:00', '2022-11-03 00:09:00', '1', '234', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('744fbd0e-cbb7-11ec-afce-2cfda1aeea94', 'WYwDDTvH', 'a3eacd0e-9326-11ec-af45-2cfda1aeea94', '2', '2', '1', '2022-10-21 12:48:00', '2022-10-21 16:06:00', '3', '189', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('744fbd0f-cbb7-11ec-adb1-2cfda1aeea94', 'OOkzvIZH', 'a3eacd0e-9326-11ec-af45-2cfda1aeea94', '3', '2', '2', '2022-10-11 16:11:00', '2022-10-11 21:43:00', '0', '104', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('744fbd10-cbb7-11ec-bae6-2cfda1aeea94', 'ReqrwerX', 'a3eacd0d-9326-11ec-bc8f-2cfda1aeea94', '1', '2', '1', '2022-08-25 23:36:00', '2022-08-26 03:07:00', '1', '81', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('744fbd11-cbb7-11ec-839d-2cfda1aeea94', 'CPLuyYjr', 'a3eacd0d-9326-11ec-bc8f-2cfda1aeea94', '10', '2', '0', '2022-07-21 12:29:00', '2022-07-21 16:21:00', '0', '33', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('744fbd12-cbb7-11ec-bd90-2cfda1aeea94', 'DkyzAxrm', 'a3eacd0c-9326-11ec-a6f9-2cfda1aeea94', '5', '2', '2', '2022-12-27 11:44:00', '2022-12-27 16:57:00', '1', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('74521f2f-cbb7-11ec-a8cb-2cfda1aeea94', 'bGnJiOZs', 'a3eacd0c-9326-11ec-a6f9-2cfda1aeea94', '8', '2', '2', '2022-08-07 21:47:00', '2022-08-08 01:56:00', '3', '232', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('74521f30-cbb7-11ec-a8db-2cfda1aeea94', 'SaObfmbc', 'a3eacd0b-9326-11ec-ba9f-2cfda1aeea94', '10', '2', '1', '2022-01-21 13:51:00', '2022-01-21 16:02:00', '3', '133', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('74521f31-cbb7-11ec-8c18-2cfda1aeea94', 'tlGQOxDe', 'a3eacd0b-9326-11ec-ba9f-2cfda1aeea94', '5', '2', '1', '2022-10-14 15:30:00', '2022-10-14 18:35:00', '1', '138', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('74521f32-cbb7-11ec-abec-2cfda1aeea94', 'IeLKHioT', 'a3eacd0a-9326-11ec-835a-2cfda1aeea94', '10', '2', '2', '2022-10-18 19:11:00', '2022-10-18 22:57:00', '2', '131', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('74521f33-cbb7-11ec-8372-2cfda1aeea94', 'afGuFGxC', 'a3eacd0a-9326-11ec-835a-2cfda1aeea94', '6', '2', '0', '2022-10-24 14:57:00', '2022-10-24 16:07:00', '3', '117', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('74521f34-cbb7-11ec-8045-2cfda1aeea94', 'FvqDjcNN', 'a3eaa615-9326-11ec-bd5b-2cfda1aeea94', '2', '2', '2', '2022-04-12 15:17:00', '2022-04-12 17:54:00', '0', '170', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into events(id, title, location_id, grade, status, type, starting_time, ending_time, season, amount_spent, context_id) values('74521f35-cbb7-11ec-b624-2cfda1aeea94', 'cmMCVkiN', 'a3eaa615-9326-11ec-bd5b-2cfda1aeea94', '3', '2', '0', '2022-07-18 14:19:00', '2022-07-18 17:09:00', '2', '237', 'f430c649-b67e-47c7-8e2a-7123796bea70');

select count(*) from people;

select id from locations;

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
values('a3eacd12-9326-11ec-a896-2cfda1aeea94', 45.657974, 25.601198, 'Ploiesti', 'Romania');

insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bd5163-cbaf-11ec-833e-2cfda1aeea94', 'Pamela', 'Carr', '1', '0', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bd5164-cbaf-11ec-9a69-2cfda1aeea94', 'Victor', 'Allen', '2', '1', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bd5165-cbaf-11ec-a7e8-2cfda1aeea94', 'Amanda', 'Rowe', '3', '0', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bd5166-cbaf-11ec-b5b8-2cfda1aeea94', 'Kenneth', 'Randolph', '4', '1', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bd5167-cbaf-11ec-b629-2cfda1aeea94', 'Elizabeth', 'Conger', '5', '0', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bd5168-cbaf-11ec-a382-2cfda1aeea94', 'Charles', 'Miranda', '6', '1', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bd5169-cbaf-11ec-a941-2cfda1aeea94', 'Lillian', 'Alford', '7', '0', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bd516a-cbaf-11ec-ad1a-2cfda1aeea94', 'Brian', 'Jones', '8', '1', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bd516b-cbaf-11ec-9e80-2cfda1aeea94', 'Bernice', 'Daniels', '9', '0', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bd516c-cbaf-11ec-af4c-2cfda1aeea94', 'Gene', 'Silva', '10', '1', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bfb398-cbaf-11ec-b08c-2cfda1aeea94', 'Gladys', 'Finch', '11', '0', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bfb399-cbaf-11ec-9726-2cfda1aeea94', 'Steve', 'Sherrill', '12', '1', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bfb39a-cbaf-11ec-9a4b-2cfda1aeea94', 'Mary', 'Patel', '13', '0', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bfb39b-cbaf-11ec-9297-2cfda1aeea94', 'David', 'Donovan', '14', '1', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bfb39c-cbaf-11ec-8c41-2cfda1aeea94', 'Lillian', 'Fox', '15', '0', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bfb39d-cbaf-11ec-ba30-2cfda1aeea94', 'Stephen', 'Owens', '16', '1', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bfb39e-cbaf-11ec-9935-2cfda1aeea94', 'Sherry', 'Morgan', '17', '0', '3', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bfb39f-cbaf-11ec-bae5-2cfda1aeea94', 'Bradly', 'Coble', '18', '1', '2', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9bfb3a0-cbaf-11ec-986d-2cfda1aeea94', 'Marlen', 'Demaire', '19', '0', '2', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9c7d8be-cbaf-11ec-9e8b-2cfda1aeea94', 'Clyde', 'Hofmann', '20', '1', '2', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9c7d8bf-cbaf-11ec-937b-2cfda1aeea94', 'Laurie', 'Campbell', '21', '0', '2', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9c7d8c0-cbaf-11ec-af68-2cfda1aeea94', 'Nicholas', 'Nevin', '22', '1', '2', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ca3c37-cbaf-11ec-8bab-2cfda1aeea94', 'Brenda', 'Brenner', '23', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ca3c38-cbaf-11ec-9fc2-2cfda1aeea94', 'Robert', 'Johnston', '24', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ca3c39-cbaf-11ec-8f10-2cfda1aeea94', 'Olivia', 'Sherrill', '25', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ca3c3a-cbaf-11ec-b74e-2cfda1aeea94', 'Joe', 'Wong', '26', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ca3c3b-cbaf-11ec-b0a7-2cfda1aeea94', 'Bernice', 'Bryant', '27', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ca3c3c-cbaf-11ec-9bad-2cfda1aeea94', 'Gary', 'Keirn', '28', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9cef07a-cbaf-11ec-8859-2cfda1aeea94', 'Nancy', 'Hill', '29', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9cf1772-cbaf-11ec-a8e6-2cfda1aeea94', 'Frank', 'Marquez', '30', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9cf3e62-cbaf-11ec-83c9-2cfda1aeea94', 'Bernice', 'Davis', '31', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9cf3e63-cbaf-11ec-9b61-2cfda1aeea94', 'Dennis', 'Bring', '32', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9d261f8-cbaf-11ec-8d92-2cfda1aeea94', 'Sue', 'Young', '33', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9d261f9-cbaf-11ec-b6fc-2cfda1aeea94', 'Kerry', 'Rodgers', '34', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9d29e60-cbaf-11ec-956f-2cfda1aeea94', 'Joanne', 'Swink', '35', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9d33c4e-cbaf-11ec-b570-2cfda1aeea94', 'Oscar', 'Hrabal', '36', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9d801be-cbaf-11ec-a5fc-2cfda1aeea94', 'Faye', 'Thurlow', '37', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9da62f1-cbaf-11ec-8521-2cfda1aeea94', 'Ernesto', 'Yost', '38', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9da62f2-cbaf-11ec-9933-2cfda1aeea94', 'Nancy', 'Tarin', '39', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9da62f3-cbaf-11ec-8556-2cfda1aeea94', 'Victor', 'Childress', '40', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9da62f4-cbaf-11ec-9d7b-2cfda1aeea94', 'Raquel', 'Harris', '41', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9da62f5-cbaf-11ec-91cc-2cfda1aeea94', 'Michael', 'Clemente', '42', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9dcc640-cbaf-11ec-a755-2cfda1aeea94', 'Kristine', 'Campbell', '43', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9dcc641-cbaf-11ec-832c-2cfda1aeea94', 'Joe', 'Thomson', '44', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9dcc642-cbaf-11ec-b857-2cfda1aeea94', 'Sara', 'Lineberry', '45', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9dcc643-cbaf-11ec-b7fd-2cfda1aeea94', 'Seth', 'Grant', '46', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9dcc644-cbaf-11ec-878e-2cfda1aeea94', 'Patricia', 'Fisher', '47', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9dcc645-cbaf-11ec-b8a6-2cfda1aeea94', 'James', 'Harris', '48', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9dcc646-cbaf-11ec-b46b-2cfda1aeea94', 'Yuki', 'Owens', '49', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9dcc647-cbaf-11ec-a65b-2cfda1aeea94', 'Cole', 'Evans', '50', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9dcc648-cbaf-11ec-8a43-2cfda1aeea94', 'Lee', 'Chun', '51', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9df286a-cbaf-11ec-b750-2cfda1aeea94', 'William', 'Britt', '52', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9df286b-cbaf-11ec-9e1e-2cfda1aeea94', 'Edith', 'Mcleary', '53', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9e1b1e0-cbaf-11ec-94da-2cfda1aeea94', 'Shawn', 'Jenkins', '54', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9e1b1e1-cbaf-11ec-98f5-2cfda1aeea94', 'Irene', 'Bell', '55', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9e1b1e2-cbaf-11ec-9b9c-2cfda1aeea94', 'Martin', 'Greer', '56', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9e1b1e3-cbaf-11ec-9174-2cfda1aeea94', 'Sallie', 'Struck', '57', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9e1b1e4-cbaf-11ec-9f29-2cfda1aeea94', 'Bob', 'Deruyter', '58', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9e67677-cbaf-11ec-abdc-2cfda1aeea94', 'Michelle', 'Franklin', '59', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9e67678-cbaf-11ec-b5e3-2cfda1aeea94', 'Roy', 'Stewart', '60', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9e67679-cbaf-11ec-b54f-2cfda1aeea94', 'Hilda', 'Pastore', '61', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9e6767a-cbaf-11ec-be32-2cfda1aeea94', 'Donald', 'Fischer', '62', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9e6767b-cbaf-11ec-a903-2cfda1aeea94', 'Robin', 'Ness', '63', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9e6767c-cbaf-11ec-abc0-2cfda1aeea94', 'Lloyd', 'Saetern', '64', '1', '0', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ec59ca-cbaf-11ec-b289-2cfda1aeea94', 'Lorraine', 'Stumpf', '65', '0', '4', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1fe4-cbaf-11ec-be41-2cfda1aeea94', 'Gregg', 'Howell', '66', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1fe5-cbaf-11ec-bbf4-2cfda1aeea94', 'Lucretia', 'Painter', '67', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1fe6-cbaf-11ec-b3da-2cfda1aeea94', 'Robert', 'Holloway', '68', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1fe7-cbaf-11ec-8994-2cfda1aeea94', 'Melanie', 'Owens', '69', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1fe8-cbaf-11ec-8283-2cfda1aeea94', 'James', 'Williams', '70', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1fe9-cbaf-11ec-b3ab-2cfda1aeea94', 'Lori', 'Powers', '71', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1fea-cbaf-11ec-a3e8-2cfda1aeea94', 'Lloyd', 'Burns', '72', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1feb-cbaf-11ec-8c21-2cfda1aeea94', 'Amanda', 'Price', '73', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1fec-cbaf-11ec-b695-2cfda1aeea94', 'Gabriel', 'Soto', '74', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1fed-cbaf-11ec-8471-2cfda1aeea94', 'Nancy', 'Ross', '75', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1fee-cbaf-11ec-a27d-2cfda1aeea94', 'Andrew', 'Dorsey', '76', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1fef-cbaf-11ec-8e9f-2cfda1aeea94', 'Catalina', 'Whittaker', '77', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1ff0-cbaf-11ec-8ac3-2cfda1aeea94', 'Donald', 'Solomon', '78', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1ff1-cbaf-11ec-b65e-2cfda1aeea94', 'Nancy', 'Nelson', '79', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1ff2-cbaf-11ec-816c-2cfda1aeea94', 'Kevin', 'Norwood', '80', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1ff3-cbaf-11ec-ada3-2cfda1aeea94', 'Krista', 'Littlejohn', '81', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ed1ff4-cbaf-11ec-a96d-2cfda1aeea94', 'Arthur', 'Clower', '82', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9ef822d-cbaf-11ec-8850-2cfda1aeea94', 'Mary', 'Calnick', '83', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9f61a26-cbaf-11ec-9b0d-2cfda1aeea94', 'Jeffrey', 'Pyles', '84', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9f61a27-cbaf-11ec-b56a-2cfda1aeea94', 'Lesia', 'Clark', '85', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9f61a28-cbaf-11ec-bd0a-2cfda1aeea94', 'Charles', 'Fajardo', '86', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9f87c5f-cbaf-11ec-b693-2cfda1aeea94', 'Sarah', 'Senno', '87', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('c9fd40ce-cbaf-11ec-9172-2cfda1aeea94', 'Bob', 'Spahr', '88', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('ca00409c-cbaf-11ec-9eca-2cfda1aeea94', 'Eve', 'Searle', '89', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('ca00409d-cbaf-11ec-8578-2cfda1aeea94', 'Mario', 'Harrison', '90', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('ca00409e-cbaf-11ec-a9f2-2cfda1aeea94', 'Dorothy', 'Vasquez', '91', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('ca00409f-cbaf-11ec-ac61-2cfda1aeea94', 'Steven', 'Sorel', '92', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('ca02a423-cbaf-11ec-a69b-2cfda1aeea94', 'Sarah', 'Baucum', '93', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('ca076895-cbaf-11ec-bad9-2cfda1aeea94', 'Gregory', 'Coughlin', '94', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('ca076896-cbaf-11ec-9509-2cfda1aeea94', 'Doris', 'Gonzalez', '95', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('ca076897-cbaf-11ec-9d4f-2cfda1aeea94', 'Mathew', 'Jephson', '96', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('ca0e8f01-cbaf-11ec-8dd4-2cfda1aeea94', 'Laura', 'Smith', '97', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('ca0e8f02-cbaf-11ec-9c7a-2cfda1aeea94', 'Claudio', 'Payne', '98', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('ca0e8f03-cbaf-11ec-a1b7-2cfda1aeea94', 'Lana', 'Strong', '99', '0', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');
insert into people(id, firstname, lastName, age, gender, social_status, context_id) values('ca0e8f04-cbaf-11ec-9b92-2cfda1aeea94', 'Michael', 'Beeson', '100', '1', '1', 'f430c649-b67e-47c7-8e2a-7123796bea70');*/
