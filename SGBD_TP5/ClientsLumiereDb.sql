create database ClientsLumiereDb;
use ClientsLumiereDb;

create table CLIENT (
	NumCli int primary key,
	Nom varchar(50),
	Prenom varchar(50),
	DateNaiss date,
	CP int,
	Rue varchar(50),
	Ville varchar(50)
);
create table PRODUIT (
	NumProd int primary key,
	Desi varchar(50),
	PrixUni money
);
create table COMMANDE (
	NumCli int foreign key references CLIENT (NumCli),
	NumProd int foreign key references PRODUIT (NumProd),
	primary key (NumCli, NumProd)
);

--1.  Formuler  �  l�aide  du  langage  SQL  les  requ�tes  suivantes  (sans  recopier  les  tables  �  rappel : 
--l�acc�s  aux  tables  d�un  autre  utilisateur  se  fait  en  pr�fixant  le  nom  de  la  table  par  le  nom  de 
--l�utilisateur, ex. darmont.client). 

--1-1 � Liste des clients (nom + pr�nom) qui ont command� le produit n� 102.
select Nom, Prenom from CLIENT cli, COMMANDE cmd 
where cli.NumCli = cmd.NumCli 
and NumProd = 102;  
 
--1-2 � Nom des clients qui ont command� au moins un produit de prix sup�rieur ou �gal � 500 �. 
select distinct Nom from CLIENT cli, COMMANDE cmd, PRODUIT prod 
where cli.NumCli = cmd.NumCli and cmd.NumProd = prod.NumProd 
and PrixUni >= 500; 

--1-3 � Nom des clients qui n�ont command� aucun produit. 
select Nom from CLIENT cli where not exists (
	select * from COMMANDE cmd where cmd.NumCli = cli.NumCli
 ); 

--1-4 � Nom des clients qui n�ont pas command� le produit n� 101. 
select Nom from CLIENT where NumCli not in ( 
	select NumCli from COMMANDE where NumProd = 101
 ); 

--1-5 � Nom des clients qui ont command� tous les produits
select CLIENT.Nom from CLIENT inner join COMMANDE on CLIENT.NumCli = COMMANDE.NumCli
group by Nom
having count(COMMANDE.NumProd) = (select count(*) from PRODUIT);
--ou
select Nom from CLIENT cli where not exists ( 
	select * from PRODUIT prod where not exists ( 
		select * from COMMANDE cmd
		where cmd.NumCli = cli.NumCli and cmd.NumProd = prod.NumProd
	)
); 
--ou
select Nom from CLIENT cli, COMMANDE cmd 
where cli.NumCli = cmd.NumCli 
group by Nom 
having count(distinct NumProd) = (select count(NumProd) from PRODUIT); 

--2.  Cr�er  une  vue  nomm�e clicopro permettant  de  visualiser  les  caract�ristiques  des produits 
--command�s  par  chaque  client  (attributs  �  s�lectionner :  NumCli,  Nom,  Prenom,  NumProd,  Desi, PrixUni). 
create view clicopro as 
	select cli.NumCli, Nom, Prenom, prod.NumProd, Desi, PrixUni 
	from CLIENT cli, COMMANDE cmd, PRODUIT prod 
	where cli.NumCli = cmd.NumCli and cmd.NumProd = prod.NumProd; 

--3. Lister le contenu de la vue clicopro. 
select * from clicopro;
select Nom from clicopro group by Nom;

--4.  Reformuler  les  deux  premi�res  requ�tes  de  la  question  1  en  utilisant  la  vue clicopro. Commentaire ?
select Nom, Prenom from clicopro where NumProd = 102;
select distinct Nom from clicopro where PrixUni >= 500; 

--5. Formuler les requ�tes suivantes en utilisant la vue clicopro. 

--� Pour chaque client, prix du produit le plus cher qui a �t� command�.
select Nom, max(PrixUni) as 'Prix produit plus cher command�' from clicopro group by Nom;
  
--� Pour  chaque  client  dont  le  pr�nom  se  termine  par  la lettre  �e�,  prix  moyen  des  produits command�s. 
select Nom, avg(PrixUni) from clicopro where Prenom like '%e' group by Nom;

--� Maximum des totaux des prix pour tous les produits command�s par les diff�rents clients.
-- M�thode 1 : top
select top 1 sum(PrixUni) as 'Somme Maximum' from clicopro group by NumCli order by sum(PrixUni) desc;
-- M�thode 2 : view
create view SommePrix as
select sum(PrixUni) as 'Somme' from clicopro group by NumCli;
select * from SommePrix;
select max(Somme) as 'Maximum des totaux des prix' from SommePrix;
 
--� Num�ros des produits command�s plus de deux fois. 
select NumProd from clicopro group by NumProd having count(*)>2; 

--6.  Cr�er  une  vue  nomm�e clipro bas�e sur clicopro et  permettant  d�afficher  seulement  les 
--attributs Nom, Prenom et Desi. Lister le contenu de la vue clipro.
create view clipro as 
	select Nom, Prenom, Desi from clicopro; 
select * from clipro; 

--7. D�truire la vue clicopro. Lister le contenu de la vue clipro. Conclusion ? 
drop view clicopro; 
select * from clipro;  