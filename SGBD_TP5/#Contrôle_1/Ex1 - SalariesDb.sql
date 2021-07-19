if exists (select * from sys.databases where name='SalariesDb')
drop database SalariesDb;
create database SalariesDb;
use SalariesDb;

--1. Cr�er les tables et les contraintes
create table Servicee (
	numService int primary key,
	nomService varchar(30),
	lieu varchar(30)
);
create table Salarie (
	matricule int primary key,
	nom varchar(30),
	poste varchar(30),
	email varchar(30),
	dateEmb date,
	salaire money,
	numService int foreign key references Servicee (numService),
	prime money
);
create table Projet (
	codeProjet int primary key,
	nomProjet varchar(300),
	dateDebut date,
	dateFin date
);
create table Participation (
	matricule int foreign key references Salarie (matricule),
	codeProjet int foreign key references Projet (codeProjet),
	fontion varchar(30),
	nbrJours int,
	primary key (matricule, codeProjet)
);
--a. Email valide et unique
alter table Salarie add constraint c_email
check (email like '%@%.%');
alter table Salarie add unique (email);

--b. DateFin du projet post�rieure � la DateDebut
alter table Projet add constraint c_dates
check (dateDebut <= DateFin);

--c. Salari� participe au moins 2 jours � un projet
alter table Participation add constraint c_jours
check (nbrJours >= 2);

--2. Ins�rtions
insert into Servicee values
(1, 'Direction', 'Pr�sidence'),
(2, 'Secr�tariat', 'Pr�sidence'),
(3, 'Ressources', 'D�partement Principal'),
(4, 'D�veloppement', 'D�partement Principal'),
(5, 'Communication', 'Accueil');
insert into Salarie values
(1, 'El madani Hassan', 'Pr�sident', 'elmadani@thecompany.com', '1991-11-25', 1000000000, 1, 0),
(2, 'Mandor Nour', 'Secr�taire', 'mandor@thecompany.com', '1999-01-18', 100000, 1, 10000),
(3, 'Korman Mehdi', 'Guichetier', 'korman@thecompany.com', '2008-11-25', 10000, 3, 5000),
(4, 'Zator Abdelhadi', 'Rechercheur', 'zator@thecompany.com', '2000-11-25', 20000, 3, 2000),
(5, 'El ma�lam Hasna', 'Technicienne', 'elmaalam@thecompany.com', '2002-11-25', 200000, 4, 10000),
(6, 'Safi Karima', 'H�tesse d''accueil', 'safi@thecompany.com', '2016-01-27', 5000, 5, 800);
insert into Projet values
(1, 'Application mobile de gestion de temps', '2016-01-01', '2016-11-11'),
(2, 'RPG en ligne multiplateforme', '2014-07-17', '2016-11-27'),
(3, 'Carapasse g�ante', '2000-01-01', '2016-01-01'),
(4, 'Projet X', '1999-01-01', null);
insert into Participation values
(4, 3, 'Mod�liseur', 30),
(4, 1, 'Concepteur', 10),
(5, 3, 'Testeuse de qualit�', 2),
(5, 2, 'D�veloppeuse', 60),
(1, 1, 'Principal', null);

--3. Afficher pour chaque salari� (nom salari�) le nombre de projets auxquels il a particip�
--et le nombre total des participations
select s.nom, count(*) as 'Nombre Projets', sum(nbrJours) as 'Total des participations'
from Salarie s inner join Participation p
on s.matricule = p.matricule
group by s.nom;

--4. Afficher pour chaque service (nom service) la masse salariale (salaire+prime)
--totale des salari�s
select ser.nomService, sum(Salaire+Prime) as 'Masse salariale'
from Servicee ser inner join Salarie sal
on ser.numService = sal.numService
group by ser.nomService;

--5. Afficher pour chaque service (nom service) le nombre de salari�s qui ont un salaire
--(sans prime) sup�rieur � la moyenne des salaires de tous les salari�s
select ser.nomService, count(*) as 'Nombre salari�s avec salaire > Moyenne des salaires'
from Servicee ser inner join Salarie sal
on ser.numService = sal.numService
group by ser.nomService

--6. Augmenter les salaires du service 'Ressources humaines' de:
--		- 500dh pour salari�s avec 5 ann�es d'anciennet�
--		- 900dh pour salari�s entre 5 et 15 ann�es d'anciennet�
--		- 1000dh pour le reste
update Salarie set Salaire += ( 
	case
		when floor(datediff(day,dateEmb,getdate())/365.25) = 5 then 500
		when floor(datediff(day,dateEmb,getdate())/365.25) between 5 and 15 then 900
		else 1000
	end
) where nomService='Ressources humaines';

--7. Cr�er une table ProjetEnRealisation qui a la m�me structure que la table Projet,
-- et ins�rer dans cette table les projets qui sont en cours de r�alisation
create table ProjetEnRealisation (
	codeProjet int primary key,
	nomProjet varchar(300),
	dateDebut date,
	dateFin date
);
insert into ProjetEnRealisation select * from Projet where DateFin < getdate();
select * from ProjetEnRealisation;

--8. Supprimer les salari�s qui n'ont pas particip� � aucun projet
delete from Salarie where matricule not in (select matricule from Participation);

--9. Augmenter la prime des salari�s qui ont particip� � plus de 1� projets de 10%
update Salarie set prime += 10*prime/100 where matricule in (
	select matricule from Participation
	group by matricule
	having count(*) > 10
);

--10. Afficher les salari�s qui n'ont pas particip� � aucun projet
select * from Salarie where matricule not in (select matricule from Participation);
