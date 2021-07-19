if exists (select * from sys.databases where name='ProjetsDb')
drop database ProjetsDb;

--A. Cr�er la base de donn�es :
create database ProjetsDb;
use ProjetsDb;

--1. Cr�er les tables et les contraintes
create table Servicee (
	NumService int primary key identity(1,1),
	NomService varchar(30),
	DateCreation date
);
create table Employe (
	Matricule int primary key identity(1,1),
	Nom varchar(30),
	Prenom varchar(30),
	DateNaissance date,
	Adresse varchar(20),
	Salaire money,
	Grade varchar(20),
	NumService int foreign key(NumService) references Servicee(NumService)
);
create table Projet (
	NumProjet int primary key identity(1,1),
	NomProjet varchar(300),
	Lieu varchar(50),
	NbrLimiteTaches int,
	NumService int foreign key references Servicee (NumService)
); 
create table Tache(
	NumTache int primary key,
	NomTache varchar(300),
	DateDebut date,
	DateFin date,
	Cout int,
	NumProjet int foreign key references Projet (NumProjet),
);
create table Travaille (
	Matricule int foreign key references Employe (Matricule),
	NumTache int foreign key references Tache (NumTache),
	NombreHeures int,
	primary key(Matricule, NumTache)
);
-- Ins�rtions
--Servicee (NumService, NomService, DateCreation);
insert into Servicee values
( 'Direction', '1991-11-25'),
( 'Secr�tariat', '1999-01-18'),
( 'Ressources', '1999-02-20'),
( 'D�veloppement', '1991-11-25'),
( 'Communication', '2000-11-11');
--Employe (Matricule, Nom, Prenom, DateNaissance, Adresse, Salaire, Grade, NumService);
insert into Employe values
( 'El madani', 'Hassan', '1991-11-25', 'Medina 7', 1000000000, 'Ma�tre', 1),
( 'Mandor', 'Nour', '1999-01-18', 'Hayat Street 2', 100000, 'Or', 2),
( 'Korman', 'Mehdi', '2008-11-25', 'Rakiz 111', 10000, 'Or', 3),
( 'Zator', 'Abdelhadi', '2000-11-25', 'Romaya Avenue 12', 20000, 'Platine', 3),
( 'El ma�lam', 'Hasna', '2002-11-25', 'Magid AB50', 200000, 'Diamond', 4),
( 'Safi', 'Karima', '2016-01-27', 'MID 9', 5000, 'Bronze', 5);
--Projet (NumProjet, NomProjet, Lieu, NbrLimiteTaches, NumService); 
insert into Projet values
( 'Application mobile de gestion de temps', 'D�partement Principal', 500, 4),
( 'RPG en ligne multiplateforme', 'D�partement Principal', 1000, 4),
( 'Carapasse g�ante', 'Usine Principal', 2000, 3),
( 'Projet X', null, null, null);
--Tache(NumTache, NomTache, DateDebut, DateFin, Cout, NumProjet);
insert into Tache values
(1, 'Conception du mod�le de donn�es', '2016-01-01', '2016-11-11', 8000, 1),
(2, 'Character design du personnage joueur', '2016-07-17', '2016-11-27', 17000, 2),
(3, 'Programmation de l''environement', '2016-01-18', '2016-08-19', 300000, 2),
(4, 'Construction des bases de support', '2014-03-01', '2016-06-10', 9000000, 3),
(5, 'Conception des mod�les introductifs', '2013-10-08', '2015-01-09', 17700, 3);
--Travaille (Matricule, NumTache, NombreHeures);
insert into Travaille values
(5, 1, 7560), (3, 2, 5789), (4, 2, 1287),
(4, 3, 1580), (5, 3, 100), (3, 3, 7890),
(6, 4, 120), (2, 4, 1240), (5, 5, 5899);
--Avec les contraintes suivantes :
--La contrainte CK_Employe_dateNaissance : l��ge de l�employ�  doit �tre sup�rieur � 18.
-- M�thode 1 (impr�cis jusqu � 11 mois et 30 jours pr�s)
alter table Employe add constraint CK_Employe_dateNaissance  
check ( datediff(YEAR,DateNaissance,getdate()) >= 18 );
--M�thode 2 plus pr�cis
--The Julian year, as used in astronomy and other sciences, 
--is a time unit defined as exactly 365.25 days !
alter table Employe add constraint CK_Employe_dateNaissance  
check ( (datediff(DAY,DateNaissance,getdate())/365.25) >= 18 );
--La contrainte CK_Tache_duree : une tache a une dur�e minimale de 3 jours 
--(Dur�e = Date_fin � Date_debut)
alter table Tache add constraint CK_Tache_duree  
check( datediff(day,DateDebut,DateFin) >= 3);
--La contraint CK_Tache_cout : le c�ut miniaml d�une tache est de 1000DH par jour. 
--( cout >= (Date_fin � Date_debut)j x1000 )
alter table Tache add constraint CK_Tache_cout  
check ( cout >= datediff(day,DateDebut,DateFin)*1000 and cout >= 1000 )
--Les cl�s primaires sont incr�ment�es automatiquement sauf le num�ro de la tache.
--le nom du projet doit �tre cod� en fran�ais et sensible � la casse.
SELECT * FROM fn_helpcollations();
alter table Employe alter column 
Nom varchar(50) collate French_CS_AS;

--(^_^) --2. Ajouter le champ calcul� �ge � la table Employ�.
alter table Employe add Age as 
floor( datediff(day,DateNaissance,getdate()) / 365.25 ); --Arrondissement
-- About Rounding Functions - Round, Ceiling and Floor
--ROUND - Rounds a positive or negative value to a specific length and accepts three values:
--    � Value to round
--        - Positive or negative number
--        - This data type can be an int (tiny, small, big), decimal, numeric, money or smallmoney
--    � Precision when rounding
--        - Positive number rounds on the right side of the decimal point
--        - Negative number rounds on the left side of the decimal point
--    � Truncation of the value to round occurs when this value is not 0 or not included
--CEILING - Evaluates the value on the right side of the decimal and returns the smallest integer 
--			greater than, or equal to, the specified numeric expression and accepts one value:
--    � Value to round
--FLOOR - Evaluates the value on the right side of the decimal and returns the largest integer 
--		  less than or equal to the specified numeric expression and accepts one value:
--    � Value to round

--B. Requ�tes de s�lection :

--1. Afficher les employ�s dont le nom commence avec � El � et ne se termine pas par une lettre 
--entre a et f, trier la liste par date de naissance.
select * from Employe where Nom like 'El%[^a-f]' order by DateNaissance;
-- ou
select * from Employe where Nom like 'El%[g-z]' order by DateNaissance;

--2. Afficher les noms des taches (en majuscule) qui prendrons fin ce mois ci.
select upper(NomTache) as 'Nom de la t�che' from Tache where month(DateFin) = month(getdate());

--3. Compter le nombre de grades diff�rents de l�entreprise.
select count(distinct Grade) as 'Nombre des diff�rents grades' from Employe;

--4. Afficher les employ�s qu�ont particip� � un projet affect� � un service diff�rent o� il travaille.
select Emp.*
from Employe Emp 
inner join Travaille Tra on Tra.Matricule = Emp.Matricule 
inner join Tache Tch on Tch.NumTache = Tra.NumTache
inner join Projet Prj on Tch.NumProjet = Prj.NumProjet
where Emp.NumService != Prj.NumService;

--5. Afficher les projets avec une tache de dur�e inf�rieure � 30jours et une autre sup�rieure 
--� 60jours (Dur�e d�une tache = Date de Fin � date de d�but)
select * from Projet where NumProjet in (
	select distinct NumProjet from Tache 
	where datediff(day, DateDebut, DateFin) < 30
) 
and NumProjet in (
	select distinct NumProjet from Tache 
	where datediff(day, DateDebut, DateFin) > 60
);

--6. Afficher la masse horaire travaill�e cette ann�e (travaille d�buter et terminer cette ann�e) 
--par projet (Masse horaire = somme (nombre_heure))
select Tch.NumProjet, sum(NombreHeures) as 'Masse horaire de cette ann�e'
from Travaille Tra inner join Tache Tch on Tra.NumTache = Tch.NumTache
where year(DateDebut) = year(getdate()) and year(DateFin) = year(getdate())
group by NumProjet;

--7. Afficher le matricule et le nom des employ�s qui ont particip� � la r�alisation de plusieurs projets.
select Employe.Matricule, Employe.Nom
from Employe 
inner join Travaille on Travaille.Matricule = Employer.Matricule 
inner join Tache on Tache.NumTache = Travaille.NumTache
group by Employe.Matricule, Employe.Nom
having count(distinct Tache.NumProjet) >= 2;

--8. Afficher le matricule, le nom, la date d�anniversaire et l�adresse des employ�s qui vont f�ter 
--leur anniversaire la semaine prochaine.
--M�thode 1 ------------------------------
select 
	Matricule, 
	Nom, 
	dateadd(year, datediff(year, DateNaissance, getdate()), DateNaissance) as 'Anniversaire', 
	Adresse 
from Employe
where dateadd(year, datediff(year, DateNaissance, getdate()), DateNaissance)
between
	dateadd(day, 7 - datepart(weekday,getdate()) + 1, getdate())
and
	dateadd(day, 7 - datepart(weekday,getdate()) + 6 + 1, getdate());
--M�thode 2 ------------------------------
select 
	 Matricule, 
	 Nom, 
	 dateadd(year, datediff(year, DateNaissance, getdate()), DateNaissance) as 'Anniversaire', 
	 Adresse 
from Employe
where datepart(week, dateadd(year, datediff(year, DateNaissance, getdate()), DateNaissance)) = datepart(week, getdate()) + 1;

--9. Afficher le(s) projet(s) qui se composent du plus grand nombre de t�ches.
drop view TachesParProjet;
create view TachesParProjet as
	select NumProjet, count(distinct NumTache) as 'Nombre de t�ches' from Tache
	group by NumProjet;

select * from Projet where NumProjet in (
	select NumProjet from Tache
	group by NumProjet
	having count(distinct NumTache) in (select max([Nombre de t�ches]) from TachesParProjet)
);

--(^_^) --10. Afficher la dur�e de r�alisation par projet (La dur�e de r�alisation d�un projet = 
--la date de fin de la derni�re tache de ce projet � la date de d�but de la premi�re tache du projet  
--(utiliser Min et Max))
select NumProjet, datediff(day, min(DateDebut), max(DateFin)) as 'Dur�e de r�alisation' from Tache
group by NumProjet;

--C. Requ�tes de mise � jour :

--1. Modifier les salaires des employ�s selon la r�gle suivante:
--    � sans modification pour les employ�s �g�s de moins de 58 ans,
--    � augmentation de 0.5% pour les employ�s �g�s entre 58 et 60 ans,
--    � augmentation de 5% pour les employ�s �g�s de plus que 60 ans.
update Employe set Salaire += ( 
	case
		when Age between 58 and 60 then 0.5*Salaire/100
		when Age > 60 then 5*Salaire/100
		else Salaire
	end
);

--2. Supprimer les taches non r�alis�es (une tache non r�alis�e est une tache dont 
--la date de fin est d�pass�e sans qu�elle contienne un travail).
delete from Tache where DateFin < getdate()
and NumTache not in (select distinct NumTache from Travaille);

--D. G�rer la s�curit� de la base de donn�es :

--1. Cr�er les deux profils de connexion suivants:
--    � profil SQL server : CnxGestionnaire
create login CnxGestionnaire with password='abcd1234';
--    � profil Windows : ChefProjet-PC\ChefProjet
create login [ChefProjet-PC\ChefProjet] from windows;

--2. Cr�er un utilisateur au niveau de la base de donn�es gestion_projet pour chaque profil:
--    � Gestionnaire
create user Gestionnaire from login CnxGestionnaire;
--    � ChefProjet
create user ChefProjet from login [ChefProjet-PC\ChefProjet];

--3. Attribuer les autorisations suivantes aux utilisateurs concern�s:
--    � Gestionnaire :
--      - le droit de mise � jour (insertion, modification et suppression) de toutes les tables 
--		    sauf la table � employ� �.
grant insert,update,delete on Servicee to Gestionnaire;
grant insert,update,delete on Projet to Gestionnaire;
grant insert,update,delete on Tache to Gestionnaire;
grant insert,update,delete on Travaille to Gestionnaire;
--    � ChefProjet
--      - le droit de suppression de toutes les tables sauf la table � Employ� �
grant delete on Servicee to ChefProjet;
grant delete on Projet to ChefProjet;
grant delete on Tache to ChefProjet;
grant delete on Travaille to ChefProjet;
--      - le droit de modification du champ � adresse � de la table � Employ� � (coupler avec un vue)
grant update (Adresse) on Employe to ChefProjet;
create view Vue_Adresse as
	select Adresse from Employe;
grant update on Vue_Adresse to ChefProjet;
