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