--1) Cr�er la base de donn�es�ANALYSES
create database AnalysesDb;
use AnalysesDb;
--2) Cr�er la table CLIENT en pr�cisant la cl� primaire
create table Client (
	code_client int primary key,
	nom varchar(15),
	cp_client varchar(30),
	ville_client varchar(30),
	tel varchar(10)
);
--3) Modifier les colonnes cpclient et villeclient pour qu'elles n'acceptent pas une valeur nulle.
alter table Client alter column cp_client varchar(30) not null;
alter table Client alter column ville_client varchar(30) not null;
--4) Modifier les colonnes Nom pour qu'elle prend la valeur 'Anonyme' par d�faut.
alter table Client add constraint c_nom default 'Anonyme' for Nom;
--5) Cr�er la table Echantillon en pr�cisant la cl� primaire qui commence de 10 et s'incr�mente automatiquement de 1, 
--codeclient est la cl� �trang�re vers la table Client.
create table Echantillon (
	code_echantillon int primary key,
	date_entree date,
	code_client int
);
--6) Cr�er la table Typeanalyse en pr�cisant de cl� primaire.
create table TypeAnalyse (
	ref_typeAnalayse int primary key,
	designation varchar(15),
	type_analyse varchar(30),
	prix_typeAnalyse money
);
--7) Cr�er une contrainte ck_prixTypeAnalyse qui impose de saisir un prixTypeAnalyse dans la table 
--Typeanalyse qui doit �tre entre 100 et 1000.
alter table TypeAnalyse add constraint ck_prixTypeAnalyse check(prix_typeAnalyse between 100 and 1000);
--8) Cr�er la table Realiser en pr�cisant que le couple (codeEchantillon,refTypeAnalyse) est une cl� primaire, 
--en m�me temps, codeEchantillon est une cl� �trang�re vers la table Echantillon et refTypeAnalyse est cl� �trang�re 
--vers la table TypeAnalyse.
create table Realiser (
	code_echantillon int foreign key references Echantillon(code_echantillon),
	ref_typeAnalayse int foreign key references TypeAnalyse(ref_typeAnalayse),
	date_realisation date,
	primary key(code_echantillon, ref_typeAnalayse)
);
--9 Cr�er une contrainte ck_dateRealisation qui v�rifie que la date de dateRealisation est entre 
--la date du jour m�me et 3 jours apr�s. ( date_realisation - aujourd'hui <= 3 )
alter table Realiser add constraint ck_dateRealisation check(datediff(day,getdate(),date_realisation)<=3);
--10) Supprimer la colonne rue de la table Client.
alter table Client add rue varchar(15);
alter table Client drop column rue;
--Affichage
select*from Client;