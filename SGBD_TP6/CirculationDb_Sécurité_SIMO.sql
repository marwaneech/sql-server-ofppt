--1. Ajouter les utilisateurs suivants � la base de donn�es du tpN�8 et accorder leur les permissions sp�cifi�es
create login conx with password='123'; 
create user Said for login conx;
create login conx1 with password='123'; 
create user laila for login conx1;
create login conx2 with password='123'; 
create user mourad for login conx2;
exec sp_addrolemember 'db_owner', 'Said';
create view v_perssonne
as
select CIN,nom from Personne;
grant select on v_perssonne to laila;
grant select on Accident to mourad;
grant select on Personne to mourad;
grant select on Voiture to mourad;
grant update on Accident to mourad;
--2. Interdire � said la suppression de la table personne
deny delete on Personne to Said;
--3. Supprimer � laila la lecture des champs cin et nom de la table Personne
revoke select on v_perssonne to laila;
--4. Supprimer � mourad le droit de Lecture de toutes les tables et modification de la table Accident
revoke select on Accident to mourad
revoke select on Personne to mourad
revoke select on Voiture to mourad
revoke update on Accident to mourad
--5. Cr�er un r�le personnalis� � rp1 � qui permet l�insertion et la modification de la table personne, la consultation
--de la table accident (seulement cin et date)
create role rp1
grant insert on Personne to rp1
grant update on Personne to rp1;
create view v1 as
select CIN,Date_Acc from Accident;
--6. Ajouter les utilisateurs laila et mourad � � rp1 �
exec sp_addrolemember rp1,laila;
exec sp_addrolemember rp1,mourad;
--7. Supprimer l�utilisateur laila du r�le � rp1 �
exec sp_droprolemember rp1,laila;
--8. Retirer said du r�le propri�taire de base
exec sp_droprolemember 'db_owner', 'Said';
--9. Supprimer l�utilisateur said
drop user Said;