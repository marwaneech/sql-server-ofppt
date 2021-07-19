create database CinemaDb; -- drop database CinemaDb
use CinemaDb;

--1. Cr�er les tables avec les cl�s primaires et �trang�res en respectant les r�gles suivantes :
--� CodePostal doit contenir 5 chiffres.
--� La capacit� doit �tre entre 30 et 100.
create table Ville (
	codePostal int primary key check (codePostal like '_____'),
	nomVille varchar(30)
);
create table Cinema (
	numCinema int primary key,
	nomCinema varchar(30),
	rueCinemea varchar(30),
	codePostal int foreign key references Ville (codePostal)
	on delete set null on update cascade
);
create table Film (
	numFilm int primary key,
	titre varchar(30),
	duree int,
	producteur varchar(30)
);
create table Salle (
	numSalle int primary key,
	capacite int check (capacite between 30 and 100),
	numCinema int foreign key references Cinema (numCinema)
	on delete set null on update cascade
);
create table Projection (
	numFilm int foreign key references Film (numFilm)
	on delete cascade on update cascade,
	numSalle int foreign key references Salle (numSalle)
	on delete cascade on update cascade,
	DateProjection date,
	NbrEntrees int
	primary key(numFilm, numSalle, DateProjection)
);
--2. Introduire des donn�es pour tester.
insert into Ville values
(10011, 'Marrakech'),
(20300, 'F�s'),
(40001, 'Rabat');
insert into Cinema values
(1,'SuperMovies','Sa�da 17',10011),
(2,'PanoCinema','Merkez 102',40001),
(3,'Mogan3D','A�t Bohmid 50',20300);
insert into Film values
(80, 'Old', 1, 'Inconnu'),
(1,'Don',2,'Farhan Akhtar'),
(2,'Kal Ho Na Ho',3,'Yash Johar'),
(3,'Don 2',2,'Farhan Akhtar');
insert into Salle values
(10,50,1),
(11,30,2),
(12,100,1),
(13,100,3);
insert into Projection values
(1,10,'2012-11-01',99),
(1,10,'2013-01-23',70),
(2,12,'2012-11-01',86),
(3,13,'2012-11-01',100),
(80,11,'2010-01-01',7);
-- Affichages
select * from Ville;
select * from Cinema;
select * from Film;
select * from Salle;
select * from Projection;

--3. Afficher la liste des projections o� le nombre d�entr�es a d�pass� 80% de la capacit� de la salle de projection.
select * from Projection inner join Salle
on Projection.numSalle = Salle.numSalle
where Projection.NbrEntrees > 0.8*Salle.capacite;

--4. Afficher le nombre de salles de cin�ma par ville (nom ville).
select Ville.nomVille, count(*) as 'Nombre de salles de Cin�ma'
from Cinema
inner join Salle on Salle.numCinema = Cinema.numCinema
inner join Ville on Ville.codePostal = Cinema.codePostal
group by Ville.nomVille;

--5. Afficher la capacit� totale de chaque cin�ma (nom du cin�ma).
select Cinema.nomCinema, sum(Salle.capacite) as 'Capacit� totale'
from Cinema inner join Salle on Cinema.numCinema = Salle.numCinema
group by Cinema.nomCinema;

--6. Afficher le nombre de films projet� le 25/08/2011 par producteur.
select Film.producteur, count(*) as 'Nombre de films projet�s'
from Film inner join Projection on Projection.numFilm = Film.numFilm
where Projection.DateProjection = '2012-11-01'
group by Film.producteur;

--7. Afficher pour chaque film (titre du film) le nombre de projections entre le 20/10/2011 et 25/10/2011.
select Film.titre, count(*) as 'Nombre de Projections'
from Film inner join Projection on Projection.numFilm = Film.numFilm
where Projection.DateProjection between '2012-11-01' and '2013-01-23'
group by Film.titre;

--8. Afficher pour chaque cin�ma (nom du cin�ma) le nombre de projections dont le nombre total d�entr�es d�passe 150.
select Cinema.nomCinema, count(*) as 'Nombre de Projections', sum(Projection.nbrEntrees) 'Nombre total d''entr�es'
from Salle 
inner join Projection on Projection.numSalle = Salle.numSalle
inner join Cinema on Cinema.numCinema = Salle.numCinema
group by Cinema.nomCinema having sum(Projection.nbrEntrees) > 150;

--9. Supprimer les films qui ne sont pas projet�s depuis 3 ans.
delete from Film
where numFilm in (
	select numFilm from Projection
	group by numFilm
	having datediff(year, max(DateProjection), getdate()) >= 3
	--Autre M�thodes: 
	--having dateadd(year, -3, getdate()) >= max(DateProjection)
	--having dateadd(year, 3, max(DateProjection)) <= getdate()
);

--10. Supprimer les cin�mas qui contiennent au moins une salle non utilis�e depuis 10 mois.
delete from Cinema
where numCinema in (
	select numCinema
	from Salle inner join Projection on Salle.numSalle = Projection.numSalle
	group by numCinema
	having datediff(month, max(DateProjection), getdate()) >= 10
	--Autre M�thodes: 
	--having dateadd(month, -10, getdate()) >= max(DateProjection)
	--having dateadd(month, 10, max(DateProjection)) <= getdate()
);