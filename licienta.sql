create database lichenta;

create table Pacients(
    PId int primary key
);

create table Procedures(
    ProcId int primary key,
    Name varchar(300),
    Description varchar(500),
    Price int
);

create table PacientsMecicalRecords(
    PacientId int constraint fk_pacients references Pacients(PId) not null,
    ProcedureId int constraint fk_procedures references Procedures(ProcId) not null,
    primary key (PacientId, ProcedureId),
    DoctorSpecialty varchar(400)
);

select X.DoctorSpecialty as Specialty, count(X.ProcedureId) as NrOfProcedure, sum(X.Price) as AmountOfMoney from
(PacientsMecicalRecords PMR inner join Procedures P on PMR.ProcedureId = P.ProcId) as X
group by X.DoctorSpecialty
order by sum(X.Price) desc
limit 2;


create table Persoane(
    PersoanaId int primary key,
    Nume varchar(200)
);

create table Masini(
    MasinaId int primary key
);

create table Proprietar(
    PersoanaId int constraint fk_persoane references Persoane(PersoanaId) not null,
    MasinaId int constraint  fk_masini references Masini(MasinaId) not null,
    primary key (PersoanaId, MasinaId)
);

create table Accident(
    ProcesVerbalId int primary key
);

create table ParticipantiAccident(
    PersoanaId int constraint fk_persoane references Persoane(PersoanaId) not null,
    ProcesVerbalId int constraint fk_proces references Accident(ProcesVerbalId) not null,
    MasinaId int constraint  fk_masini references Masini(MasinaId) not null,
    primary key (PersoanaId, ProcesVerbalId)
);

create table S
(
    D int primary key,
    E int,
    F int
);

create table R
(
    A int primary key,
    B int,
    C int,
    D int
        constraint fk_S references S (D) not null
);

insert into R values(1, 20, 12, 5),
                     (2, 21, 11, 4),
                     (3, 26, 9, 5)


insert into S values (1, 20, 5),
                     (4, 23, 7),
                     (5, 29, 9),
                     (6, 28, 8),
                     (7, 30, 5)

select *
from R right join S on R.D = S.D

select R.D
from R inner join S on R.D = S.D
group by R.D
having count(*) > 1

