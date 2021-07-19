-- BASE DE DONNEE : NotationStagiairesDb
create database NotationStagiairesDb;
use NotationStagiairesDb;
--Soit le sch�ma relationnel suivant qui g�re la notation des stagiaires dans un institut de
--l�OFPPT, en pr�cisant que les champs marqu�s en gras et soulign�s repr�sentent les cl�s
--primaires des tables et ceux marqu�s par un # repr�sentent les cl�s �trang�res :
--Sachant qu�un module est enseign� par un seul formateur.
--Donner les requ�tes SQL qui permettent de :

--1. Cr�er les tables stagiaire et notation avec les contraintes suivantes : (4 pts)
create table Filiere(
	num_filiere int primary key,
	nom_filiere varchar(30)
);
create table Groupe(
	num_groupe int primary key,
	nom_groupe varchar(30),
	num_filiere int foreign key references Filiere (num_filiere)
	on delete set null on update cascade
);
--Dans la table stagiaire :
create table Stagiaire(
--a. Num_stagiaire doit �tre num�rique <1000 , Num_stagiaire est une cl� primaire.
	num_stagiaire int primary key check (num_stagiaire < 1000),
	nom_stagiaire varchar(30),
	prenom_stagiaire varchar(30),
	adresse varchar (300),
	email varchar(30),
--b. Num_groupe est une cl� �trang�re.
	num_groupe int foreign key references Groupe (num_groupe)
	on delete set null on update cascade
);
create table Formateur(
	num_formateur int primary key,
	nom_formateur varchar(30),
	prenom_formateur varchar(30), 
	num_filiere int foreign key references Filiere
	on delete set null on update cascade
);
create table Module(
	num_module int primary key,
	nom_module varchar(30),
	masse_horaire_prevue int,
	masse_horaire_realise int,
	num_formateur int foreign key references Formateur (num_formateur)
	on delete set null on update cascade
);
create table Controle(
	num_controle int primary key,
	date_controle date,
	num_module int foreign key references Module (num_module)
	on delete set null on update cascade
);
--Dans la table Notation :
create table Notation(
--a. Numcontr�le et Numstagiaire sont des cl�s �trang�res.
	num_stagiaire int foreign key references Stagiaire(num_stagiaire),
	num_controle int foreign key references Controle(num_controle),
--c. L�attribut Note doit �tre compris entre 0 et 20.
	note float check (note between 0 and 20),
--b. Les colonnes Numcontr�le et Numstagiare forment la cl� primaire.
	primary key (num_stagiaire, num_controle)
);
--On suppose que les autres tables sont d�j� cr��es dans la base.

--2. Lister les Stagiaires de la fili�re nomm�e �TDM� du groupe nomm� �A� et du group nomm� �B�. (2 pts)
select Stagiaire.*, Filiere.nom_filiere, Groupe.nom_groupe
from Groupe 
inner join Stagiaire on Stagiaire.num_groupe = Groupe.num_groupe
inner join Filiere on Filiere.num_filiere = Groupe.num_filiere
where Groupe.nom_groupe in ('A','B') and Filiere.nom_filiere = 'TDM';

--3. Lister le groupe (toutes les informations) ayant le plus grand nombre de stagiaire (4pts)
select top 1 Stagiaire.num_groupe, Groupe.nom_groupe, count(*) as 'Nombre de Stagiaires' 
from Stagiaire inner join Groupe on Groupe.num_groupe = Stagiaire.num_groupe
group by Stagiaire.num_groupe, Groupe.nom_groupe order by [Nombre de Stagiaires] desc;

--4. Lister les modules enseign�s par le(s) formateur(s) � ABDELLAOUI �. (1 pt)
select Module.*, Formateur.nom_formateur
from Formateur inner join Module
on Formateur.num_formateur = Module.num_formateur
where nom_formateur='LMALKI';

--5. Lister les modules d�j� termin�s. (1 pt)
select * from Module 
where masse_horaire_prevue=masse_horaire_realise;

--6. Lister les modules non termin�s et enseign�s par le formateur �ahmadi � pour la fili�re �TDM�. (1 pt)
select Module.*, Formateur.nom_formateur, Filiere.nom_filiere 
from Formateur 
inner join Filiere on Filiere.num_filiere = Formateur.num_filiere
inner join Module on Module.num_formateur = Formateur.num_formateur
where Module.masse_horaire_prevue > Module.masse_horaire_realise 
and Formateur.prenom_formateur='ahmadi' and Filiere.nom_filiere='TDM';

--7. Supprimer tous les groupes dont le nombre de stagiaires ne d�passent pas dix. (1pt)
delete from Groupe
where num_groupe = (select num_groupe from Stagiaire group by num_groupe having count(*) <= 10);

--8. Affecter la note 12/20 pour le contr�le num�ro : 2 du module nomm�
--�programmation 3D� pour la fili�re �TDM� au stagiaire ayant comme num�ro : 3006. (2 pts)
-- Note : 19
-- Stagiaire : 3006
--  Cont�le : 2 (Module : Programmation)
-- Fili�re : TDM
update Notation 
set note=19
where 
num_stagiaire = ( select num_stagiaire 
				 from Groupe 
				 inner join Stagiaire on Stagiaire.num_groupe = Groupe.num_groupe
				 inner join Filiere on Filiere.num_filiere = Groupe.num_filiere
				  where num_stagiaire=3006 and nom_filiere='TDM' )
and 
num_controle = ( select  top 2 with ties num_controle from Controle inner join Module
				on Controle.num_module = Module.num_module
				 where Module.nom_module='Langage C' order by num_controle asc );
