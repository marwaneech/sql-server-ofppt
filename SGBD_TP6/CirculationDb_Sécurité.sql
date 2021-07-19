use CirculationDb;

select system_user;

--1. Ajouter les utilisateurs suivants � la base de donn�es du tpN�8 et accorder leur les permissions sp�cifi�es
create login Said_cnx with password='abcd1234';
create login Laila_cnx with password='abcd1234';
create login Mourad_cnx with password='abcd1234';
create user Said for login Said_cnx;
create user Laila for login Laila_cnx;
create user Mourad for login Mourad_cnx;
--exec sp_droprolemember 'db_owner', 'Said';
exec sp_addrolemember 'db_owner', 'Said';

--2. Interdire � said la suppression de la table personne
deny delete on Personne to Said;

--3. Supprimer � laila la lecture des champs cin et nom de la table Personne
create view P as
select CIN,nom from Personne;
revoke select on P to Laila;

--4. Supprimer � mourad le droit de Lecture de toutes les tables et modification de la table Accident
revoke select on Personne to Mourad;
revoke select on Voiture to Mourad;
revoke select on Accident to Mourad;
revoke update on Accident to Mourad;

--5. Cr�er un r�le personnalis� � rp1 � qui permet l�insertion et la modification de la table personne, la
--consultation de la table accident (seulement cin et date)
create role rp1;
grant insert on Personne to rp1;
grant update on Personne to rp1;
create view A as
select CIN, Date_Acc from Accident;
grant select on A to rp1;

--6. Ajouter les utilisateurs laila et mourad � � rp1 �
exec sp_addrolemember rp1, Laila;
exec sp_addrolemember rp1, Mourad;

--7. Supprimer l�utilisateur laila du r�le � rp1 �
exec sp_droprolemember rp1, Laila;

--8. Retirer said du r�le propri�taire de base
exec sp_droprolemember 'db_owner', 'Said';

--9. Supprimer l�utilisateur said
drop user Said;