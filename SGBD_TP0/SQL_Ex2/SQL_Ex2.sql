--1) Cr�er la base de donn�es GestionLogement
create database GestionLogementDb;
use GestionLogementDb;

--2) Cr�er les cinq tables en d�signant les cl�s primaires 
-- mais pas les cl�s �trang�res.
create table Quartier (
	id_quartier int primary key,
	id_commune int,
	libelle_quartier varchar(3)
);
create table Commune (
	id_commune int primary key,
	nom_commune varchar(30),
	distance_agence float,
	nombre_habitants int
);
create table Logement (
	num_logement int primary key,
	type_logement varchar(30),
	id_quartier int,
	noo int,
	rue varchar(30),
	superficie float,
	loyer float
);
create table TypeLogement (
	type_logement varchar(30) primary key,
	charge_forfitaire varchar(30)
);
create table Individu (
	num_identification int primary key,
	num_logement int,
	nom varchar(30),
	prenom varchar(30),
	date_naissance date,
	num_telephone varchar(30)
);

--3) Cr�er les contraintes permettant de pr�ciser les cl�s �trang�res 
-- avec suppression et modification en cascade.
alter table Quartier add constraint fk_commune foreign key (id_commune) references Commune(id_commune);
alter table Logement add constraint fk_typelog foreign key (type_logement) references TypeLogement(type_logement);
alter table Logement add constraint fk_quartier foreign key (id_quartier) references Quartier(id_quartier);
alter table Individu add constraint fk_logement foreign key (num_logement) references Logement(num_logement);

--4) Modifier la colonne N_TELEPHONE de la table INDIVIDU 
-- pour qu�elle n�accepte pas la valeur nulle.
alter table Individu alter column num_telephone varchar(30) not null;

--5) Cr�er une contrainte df_Nom qui permet d�affecter �SansNom� 
-- comme valeur par d�faut � la colonne Nom de la table INDIVIDU.
alter table Individu add constraint df_nom default 'SansNom' for Nom;

--6) Cr�er une contrainte ck_dateNaissance sur la colonne DATE_DE_NAISSANCE 
-- qui emp�che la saisie d�une date post�rieure � la date d�aujourd�hui 
-- ou si l��ge de l�individu ne d�passe pas 18 ans.
alter table Individu add constraint ck_datenaiss 
check ( datediff(year,date_naissance,getdate()) <= 18 );

--7) Supprimer la contrainte df_Nom que vous avez d�fini dans la question 5.
alter table Individu drop constraint df_nom;
