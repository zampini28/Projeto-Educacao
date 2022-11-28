drop database if exists bd_escola;
create database bd_escola;
use bd_escola;

create table Membro_instituicao(
ID int,
cpf varchar(11) not null,
rg int not null,
n_telefone varchar(20),
nome varchar(50) not null,
e_mail varchar(50) not null,
constraint pk_membro_instituicao primary key (ID));

create table materia(
ID int,
materia varchar(20),
constraint pk_materia primary key (ID));

create table turma(
ID1 int,
materia int,
constraint pk_turma primary key (id1,materia),
constraint fk_materia foreign key (materia) references materia(ID));

create table Professor(
ID int,
cpf varchar(11) not null,
rg int not null,
n_telefone varchar(20),
nome varchar(50) not null,
e_mail varchar(50) not null,
assunto varchar(50) not null,
constraint pk_professor primary key (ID));

create table Aluno(
ID int,
cpf varchar(11) not null,
rg int not null,
n_telefone varchar(20),
nome varchar(50) not null,
e_mail varchar(50) not null,
turma int,
constraint pk_aluno primary key (ID),
constraint fk_turma foreign key (turma) references turma(ID1));

create table responsavel(
ID int,
cpf varchar(11) not null,
rg int not null,
n_telefone varchar(20),
nome varchar(50) not null,
e_mail varchar(50) not null,
aluno int,
constraint pk_responsavel primary key (ID),
constraint fk_aluno foreign key (aluno) references aluno(ID));

insert into materia values(1,"português");
insert into materia values(2,"história");
insert into materia values(3,"matematica");
insert into materia values(4,"biologia");
insert into materia values(5,"quimica");
insert into materia values(6,"inglês");

insert into turma values(1,1);
insert into turma values(1,2);
insert into turma values(1,3);
insert into turma values(2,4);
insert into turma values(2,5);
insert into turma values(2,6);


insert into aluno values(221001,12345678912,123456123,948652153,"joão","joaosilva@gmail.com",1);
insert into aluno values(221002,98765432198,456789459,957841259,"henrique","shadowvr@gmail.com",2);
insert into aluno values(221003,65498732165,789123786,921587649,"soares","dragaogg@hotmail.com",1);

insert into responsavel values(220001,14725836914,147258145,964871584,"ernesto","purloviaprodutos@gmail.com",221001);
insert into responsavel values(220002,25836914725,159753468,949751486,"tiffany","otterdesign@gmail.com",221002);
insert into responsavel values(220003,36914725836,248615972,914867542,"francisco","cisco001@gmail.com",221003);

insert into membro_instituicao values(10001,15423647815,572481538,971456892,"jonattan","jpth4@uol.com");
insert into membro_instituicao values(10005,12938747815,572424458,975643892,"josé","jowshe023@uol.com");
insert into membro_instituicao values(10002,15648462148,489813214,948632181,"luiz","luizinhopipoco@hotmail.com");
insert into membro_instituicao values(10003,64851887951,449515472,944886572,"jorel","renatojbl@hotmail.com");

insert into professor values(11001,47695812346,476845237,924879536,"rafael","gonçalvediaz@gmail.com","português");
insert into professor values(11002,46897513486,248756498,997864251,"antonio","tonycleber@gmail.com","matematica");
insert into professor values(11003,38547654521,247951612,971542761,"luiza","antonietaluiza@gmail.com","história");

update professor set assunto = "quimica" where id = 11002;
update aluno set e_mail = "dragaogg@gmail.com" where id= 221003;
update responsavel set n_telefone = "931794867" where id = 220001;
delete from membro_instituicao where id=10003;

create view visao_professor as
select p.nome, p.assunto, t.id1 as turma from professor as p, turma as t, materia as m where p.assunto = m.materia and m.id = t.materia ;
select * from visao_professor;

delimiter //
create procedure consulta_alunos_turmas(in turmaid int)
begin
select nome from aluno where turma = turmaid;
end;//

call consulta_alunos_turmas(1);
