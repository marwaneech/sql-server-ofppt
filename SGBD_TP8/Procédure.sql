use GCommandeDb;
--=================================================================
-- * Cr�er les proc�dures stock�es suivantes :
--=================================================================
--Proc�dure qui affiche la liste des articles avec pour chaque 
--article le num�ro et la d�signation :
create proc sp_articles as
select NumArt, DesArt from Article;
--Ex�cuter :
exec sp_articles;
--=================================================================
--Proc�dure qui calcule le nombre d'articles par commande :
create proc sp_NbrArticlesParCommande as
select Commande.NumCom, DatCom, count(NumArt) as 'Nombre d''articles'
from Commande, LigneCommande 
where Commande.NumCom = LigneCommande.NumCom 
group by Commande.NumCom, DatCom;
--Ex�cuter :
exec sp_NbrArticlesParCommande;
--=================================================================
--Proc�dure qui afficher les commandes entre deux dates donn�es :
alter proc sp_commandes_par_date
@date_min date, @date_max date 
as
if (@date_min > @date_max) print('Erreur! La 1�re date doit �tre ant�rieure � la 2�me.');
else select * from Commande where DatCom between @date_min and @date_max;
--Ex�cuter :
exec sp_commandes_par_date '01-01-2016', '02-01-2016';
exec sp_commandes_par_date '03-01-2016', '02-01-2016';
--================================================================= 
--Proc�dure pour stocker le nombre de commandes dans une variable :
create proc sp_nbr_commandes
@nbr_com int output
as
set @nbr_com = (select count(*) from Commande);
--Ex�cuter :
declare @n int;
exec sp_nbr_commandes @n output;
select @n as 'Nombre de commandes';
--=================================================================
--Proc�dure pour stocker le nombre de d'articles command�s
--d'une commande donn�e dans une variable :
create proc sp_nbr_articles_par_commande
@NumCom int, @nbr_art int output
as
set @nbr_art = (select count(*) from LigneCommande where NumCom = @NumCom);
--Ex�cuter :
declare @n int;
exec sp_nbr_articles_par_commande 3, @n output;
select @n as 'Nombre d''articles de la commande';
--=================================================================
--Proc�dure pour stocker le montant et l'�tat d'une commande
--dans des variables
create proc sp_montant_commande
@NumCom int, @montant money output, @couleur varchar(max) output
as
set @montant = (select sum(A.PUArt*LC.QteCommandee) 
			     from Article A inner join LigneCommande LC
			     on A.NumArt = LC.NumArt
			     where NumCom = @NumCom); 
if (@montant between 0 and 1000)
	set @couleur = 'Verte';
else if (@montant between 1000 and 8000)
	set @couleur = 'Orange';
else if (@montant > 300)
	set @couleur = 'Rouge';
--Ex�cuter :
declare @m money, @c varchar(max);
exec sp_montant_commande 3, @m output, @c output;
print('Montant : ' + convert(varchar, @m) + ' DH .......... Commande ' + @c); 
--=================================================================
--Proc�dure pour retourner le montant et l'�tat d'une commande
--dans des variables
create proc sp_max_prix
as
declare @max_prix money = (select max(PUArt) from Article);
return @max_prix;
--Ex�cuter :
declare @p money;
exec @p = sp_max_prix;
select @p as 'Maximum des prix d''articles';
--=================================================================
--Ex�cuter :
--=================================================================
--Ex�cuter :
--=================================================================
--Ex�cuter :
--=================================================================
--Ex�cuter :
--=================================================================
--Ex�cuter :
--=================================================================
--Ex�cuter :
--=================================================================
--Ex�cuter :
--=================================================================
--Ex�cuter :
--=================================================================