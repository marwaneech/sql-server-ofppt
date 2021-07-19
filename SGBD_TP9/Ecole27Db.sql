create database Ecole27Db;
use Ecole27Db;

CREATE TABLE Stagiaire (
    Num�ro varchar(50) primary key,
    Nom varchar(50),
	DateNaissance date,
	Note float
);

create trigger ConfrimInsert
on Stagiaire
	after insert
as
begin
	print 'Ajout�e avec succ�s!';			 
end

insert into Stagiaire values
(1, 'Hamid', '11-01-1995', 20)

