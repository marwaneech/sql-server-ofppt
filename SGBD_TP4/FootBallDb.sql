--Une application de gestion des r�sultats des matchs de football de la saison 2011-2012
--utilise la base de donn�es suivante :
create database FootBallDb;
use FootBallDb;
create table Equipe (
	codeEquipe int primary key,
	nomEquipe varchar(50),
);
create table Stade (
	codeStade int primary key,
	nomStade varchar(50)
);
create table Match (
	numMatch int primary key,
	dateMatch date,
	nombreSpectateur int,
	numJournee int,
	codeStade int foreign key references Stade (codeStade),
	codeEquipeLocaux int foreign key references Equipe (codeEquipe),
	codeEquipeVisiteurs int foreign key references Equipe (codeEquipe),
	nombreButLocaux int,
	nombreButVisiteurs int
);

--Un match se joue entre une �quipe locale et une �quipe visiteur dans un stade donn� et
--pour une journ�e du championnat national (journ�e 1, 2 , �). La table Match enregistre
--�galement le nombre de buts marqu�s par l��quipe des locaux et le nombre de buts marqu�s
--par l��quipe des visiteurs.
insert into Equipe values
(1,'Angels'),(2,'Devils'),(3,'Dragons'),(4,'Wings'),(5,'Basiliks'),
(6,'Phoenix'),(7,'BlackCrows'),(8,'BlueCrows'),(9,'Snakes'),(10,'Panthers');
select * from Equipe;

insert into Stade values
(1,'Hall of Rebirth'),(2,'Titanium'),(3,'Final Colossum');
select * from Stade;

insert into Match values
(1, '2016-01-01', 4000, 1, 1, 1,2, 0,0),
(2, '2016-01-01', 3900, 1, 1, 7,8, 2,1),
(3, '2016-01-02', 2000, 2, 1, 3,10, 5,4),
(4, '2016-01-03', 5000, 3, 2, 1,2, 2,1);
select * from Match;

--1) Ecrire une requ�te qui affiche le nombre de matchs jou�s dans la journ�e n�12. (0,5pt)
select count(*) as 'Nombre de matchs jou�s' from Match where numJournee=2;

--2) Ecrire une requ�te qui affiche le nombre de matchs jou�s par journ�e. (0,5 pt)
select numJournee, count(*) as 'Nombre de matchs jou�s' from Match group by numJournee;

--3) Ecrire une requ�te qui affiche le match qui a compt� le plus grand nombre de spectateurs. (1pt)
select * from Match where nombreSpectateur in ( select max(nombreSpectateur) from Match );

--4) Ecrire une requ�te qui affiche le nombre de points de l��quipe de code 112 ; le
--nombre de points se calcule de la fa�on suivante :        (1 pt)
--			� une victoire = 3 points 
--			� une �galit� = 1 point 
--			� une d�faite = 0 point
declare @CodeEquipe int = 1 -- Code de l'�quipe pour laquelle afficher les points
declare @Points int = 0
select  @Points += count(numMatch)*3 from Match where 
	( codeEquipeLocaux = @CodeEquipe and nombreButLocaux > nombreButVisiteurs ) 
	or 
	( codeEquipeVisiteurs = @CodeEquipe and nombreButVisiteurs > nombreButLocaux )

select @Points += count(numMatch) from Match where 
	( codeEquipeLocaux = @CodeEquipe or codeEquipeVisiteurs = @CodeEquipe ) and nombreButLocaux = nombreButVisiteurs

select @Points as 'Nomrbe de points de l''�quipe';

--5) Ecrire une proc�dure stock�e qui affiche les �quipes qui ont gagn� leur match dans
--une journ�e dont le num�ro est donn� comme param�tre. (1 pt)


--6) Ecrire un trigger qui refuse l�ajout d�une ligne � la table Match pour laquelle la colonne
--codeEquipeLocaux est �gale � la colonne codeEquipeVisiteurs. (1 pt)

--Avec Trigger
create trigger tr_locaux_VS_visiteurs on Match -- drop trigger tr_locaux_VS_visiteurs
for insert as
begin
	declare @local int
	declare @visiteur int
	select @local = codeEquipeLocaux from inserted
	select @visiteur = codeEquipeVisiteurs from inserted
	if (@local = @visiteur)
	raiserror('L''�quipe %d ne peut pas �tre locaux et visiteurs en m�me temps !', 10, 1, @local)
end

--Possible aussi avec contrainte 
alter table Match -- alter table Match drop constraint c_locaux_VS_visiteurs
add constraint c_locaux_VS_visiteurs 
check (codeEquipeLocaux != codeEquipeVisiteurs);

--requ�te insert de test
-- numMatch, dateMatch, nombreSpectateur, numJournee, codeStade, 
-- codeEquipeLocaux, codeEquipeVisiteurs, 
-- nombreButLocaux, nombreButVisiteurs

insert into Match values
(99,'2016-01-30',0,1,1,  9,9,  0,0);
-----------------
delete from Match where numMatch=99;
-----------------
select * from Match;