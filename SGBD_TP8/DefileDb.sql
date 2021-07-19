--///////////////////////////////////////////////////////////////
create database DefileDb;
use DefileDb;
--///////////////////////////////////////////////////////////////
create table MemebreJury (
	NumMemebreJury int primary key,
	NomMemebreJury varchar(50),
	FonctionMemebreJury varchar(50)
);
create table Styliste (
	NumStyliste int primary key,
	NomStyliste varchar(30),
	AdrStyliste varchar(100)
);
create table Costume (
	NumCostume int primary key,
	DesignationCostume varchar(30),
	NumStyliste int foreign key references Styliste (NumStyliste)
	on delete set null on update cascade
);
create table NoteJury (
	NumCostume int foreign key references Costume (NumCostume)
	on delete set null on update cascade,
	NumMemebreJury int foreign key references MemebreJury (NumMemebreJury)
	on delete set null on update cascade,
	NoteAttribu�e float,
	primary key (NumCostume, NumMemebreJury) 
);
create table Fonction (
	Fonction int primary key
);
--///////////////////////////////////////////////////////////////
--Cr�er les proc�dures stock�es suivantes :
--(On propose aussi de r��crire chaque proc�dure en tant que fonction)
--///////////////////////////////////////////////////////////////

--==================================================================================================
--PS 1. Qui affiche la liste des costumes avec pour chaque costume le num�ro, la
--d�signation, le nom et l'adresse du styliste qui l'a r�alis�.
--**************************************************************
-- Proc�dure :
--**************************************************************
create proc SP_ListeCostumes
as
	select C.DesignationCostume, S.NomStyliste, S.AdrStyliste  
	from Costume C inner join Styliste S on C.NumStyliste = S.NumStyliste;
-- Ex�cuter :
exec SP_ListeCostumes;
--**************************************************************
-- Fonction :
--**************************************************************
create function F_ListeCostumes() 
returns table
as
	return (select C.DesignationCostume, S.NomStyliste, S.AdrStyliste  
	from Costume C inner join Styliste S on C.NumStyliste = S.NumStyliste);
-- Ex�cuter :
select * from F_ListeCostumes();
--==================================================================================================
--PS 2. Qui re�oit un num�ro de costume et qui affiche la d�signation, le nom et
--l'adresse du styliste concern�.
--_______________________
-- Proc�dure :
create proc SP_Costume
	@NumCostume int
as
	select C.DesignationCostume, S.NomStyliste, S.AdrStyliste  
	from Costume C inner join Styliste S on C.NumStyliste = S.NumStyliste
	where NumCostume = @NumCostume;
-- Ex�cuter :
exec SP_Costume 3;
--_______________________
-- Fonction :
create function F_Costume(@NumCostume int) 
returns table
as
	return (select C.DesignationCostume, S.NomStyliste, S.AdrStyliste  
	from Costume C inner join Styliste S on C.NumStyliste = S.NumStyliste
	where NumCostume = @NumCostume);
-- Ex�cuter : 
select * from F_Costume(3);
--==================================================================================================
--PS 3. Qui re�oit un num�ro de costume et qui affiche la liste des notes attribu�es
--avec pour chaque note le num�ro du membre de jury qui l'a attribu�, son nom, sa
--fonction et la note.
--_______________________
-- Proc�dure :
create proc SP_ListeNotes
	@NumCostume int
as
	select N.NumCostume, N.NumMemebreJury, M.NomMemebreJury, 
	M.FonctionMemebreJury, N.NoteAttribu�e 
	from NoteJury N inner join MemebreJury M
	on N.NumMemebreJury = M.NumMemebreJury
	where NumCostume = @NumCostume;
-- Ex�cuter :
exec SP_ListeNotes 3;
--_______________________
-- Fonction :
create function SP_ListeNotes(@NumCostume int)
returns table
as
	return (select N.NumCostume, N.NumMemebreJury, M.NomMemebreJury, 
	M.FonctionMemebreJury, N.NoteAttribu�e 
	from NoteJury N inner join MemebreJury M
	on N.NumMemebreJury = M.NumMemebreJury
	where NumCostume = @NumCostume);
-- Ex�cuter :
exec SP_ListeNotes 3;
--==================================================================================================
--PS 4. Qui retourne le nombre total de costumes.
--_______________________
-- Proc�dure :
create proc SP_NombreTatalCostumes 
as
    select count(*) as 'Nombre total de costumes' from Costume;
-- Ex�cuter :
exec SP_NombreTatalCostumes;
--_______________________
-- Fonction :
create function F_NombreTatalCostumes()
returns int 
as
begin
	declare @nbr int = (select count(*) from Costume);
	return @nbr;
end
-- Ex�cuter
select dbo.F_NombreTatalCostumes() as 'Nombre total de costumes';
--==================================================================================================
--PS 5. Qui re�oit un num�ro de costume et un num�ro de membre de jury et qui
--retourne la note que ce membre a attribu� � ce costume.
--_______________________
-- Proc�dure :
create proc SP_Note 
    @NumCostume int,
    @NumMemebreJury int  
as
    select * from NoteJury 
	where NumCostume = @NumCostume
	and NumMemebreJury = @NumMemebreJury;
-- Ex�cuter :
exec SP_Note 1, 1;
--_______________________
-- Fonction :
create function F_Note(@NumCostume int, @NumMemebreJury int)
returns float
as
begin
    declare @Note float = (select NoteAttribu�e from NoteJury 
	where NumCostume = @NumCostume and NumMemebreJury = @NumMemebreJury);
	return @Note;
end
-- Ex�cuter :
select dbo.F_Note(1, 1) as 'Note';
--==================================================================================================
--PS 6. Qui re�oit un num�ro de costume et qui retourne sa moyenne.
--_______________________
-- Proc�dure :
create proc SP_Moyenne 
    @NumCostume int  
as
    select avg(NoteAttribu�e) as 'Moyenne' from NoteJury where NumCostume = @NumCostume;
-- Ex�cuter :
exec SP_Moyenne 1;
--_______________________
-- Fonction :
create function F_Moyenne (@NumCostume int)
returns float
as
begin
    declare @Moyenne float = (select avg(NoteAttribu�e) as 'Moyenne' 
	from NoteJury where NumCostume = @NumCostume);
	return @Moyenne;
end
-- Ex�cuter :
select dbo.F_Moyenne(1) as 'Moyenne';
--==================================================================================================
