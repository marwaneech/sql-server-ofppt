--1. Cr�er la base de donn�es EMPLOYES.
create database EmployesDb;
use EmployesDb;
create table EMP (
	Matricule varchar(30) primary key,
	Nom varchar(30),
	Prenom varchar(30),
	Salaire float,
	Commission float,
	Num_Dept int
);
create table DEPT (
	Num_Dept int primary key,
	Nom_Dept varchar(30),
	Ville_Dept varchar(30)
);
alter table EMP add constraint fk_Num_Dept
foreign key (Num_Dept) references DEPT (Num_Dept);

insert into DEPT values
(10,'Sky Marina Dept.','Marrakech'),
(20,'Rose Rosa Dept.','Rabat'),
(30,'White Alexandra Dept.','Chefchaouen');
insert into EMP values
('X1','Bariz','Ali',9000,80,10),
('X2','Roman','Kal',2000,50,30),
('X3','Robinson','Rania',3000,10,20),
('X4','Saliman','Karan',1000,70,30),
('X100','Last','The',8000,75,10);

select * from EMP;
select * from DEPT;

--2. Cr�ez une vue V_EMP contenant : le matricule, le nom, le num�ro de d�partement, la
--somme de la commission et du salaire nomm� GAINS, le lieu du d�partement.
create view V_EMP as
select Matricule, Nom, EMP.Num_Dept, 
(Salaire+(Commission*Salaire/100)) as 'GAINS', DEPT.Ville_Dept
from EMP inner join DEPT on EMP.Num_Dept = DEPT.Num_Dept;
-- Afficher la vue
select * from V_EMP;

--3. S�lectionnez les lignes de V_EMP dont le salaire total est sup�rieur � 10.000.
select * from V_EMP where GAINS > 10000;

--4. Essayez de mettre � jour le nom de l'employ� de matricule 1 � travers la vue V_EMP.
update V_EMP set Nom='Hogwartz' where Matricule='X1';

--5. Cr�ez une vue V_EMP10 qui ne contienne que les employ�s du d�partement 10 de la table
--EMP (n'utilisez pas l'option CHECK pour cette cr�ation). Ins�rez dans cette vue un
--employ� qui appartient au d�partement 20.
--Essayez ensuite de retrouver cet employ� au moyen de la vue V_EMP10 puis au moyen de
--la table EMP.
create view V_EMP10 as select * from EMP where Num_Dept=10;
insert into V_EMP10 values ('X5','Outsider','Kafien',6000,90,20);
select * from V_EMP10 where Matricule='X5';
select * from EMP where Matricule='X5';

--6. D�truisez cette vue VEMP10 et recr�ez-la avec l'option CHECK.
drop view V_EMP10;
create view V_EMP10 as select * from EMP where Num_Dept=10 with check option;

--7. Essayez d'ins�rer un employ� pour le d�partement 30. Que se passe-t-il ? Essayez de
--modifier le d�partement d'un employ� visualis� � l'aide de cette vue.
insert into V_EMP10 values ('X6','Final','Warrior',7500,50,30); -- /!\ 
select * from V_EMP10;
update V_EMP10 set Num_Dept=30 where Matricule='X100'; -- /!\

--8. Afficher la liste des matricules, noms et salaires des employ�s avec le pourcentage par
--rapport au total des salaires de leur d�partement (utilisez une vue qui fournira le total des
--salaires).
-- drop view TOTAL_SALAIRES
create view TOTAL_SALAIRES as 
select Num_Dept, sum(Salaire) as 'Somme des salaires' from EMP
group by Num_Dept;
----
select * from TOTAL_SALAIRES;
----
select Matricule, Nom, Salaire,
100*Salaire/(select [Somme des salaires] from TOTAL_SALAIRES where TOTAL_SALAIRES.Num_Dept = EMP.Num_Dept) 
as 'Pourcentage Salaire / Salaire total d�partement'
from EMP order by Salaire desc;