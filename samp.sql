create database meuservidor;

use meuservidor;

create table contas(
	id int auto_increment primary key,
    nome varchar(28),
    skin int default 1,
    grana int default 1000
);

alter table contas add column senha varchar(125) default null after id;

select * from contas;

select senha from contas where senha = 'boa tarde' and nome = 'Davidavida70';

select nome, senha from contas where nome = 'Davidavida70';


update contas set senha = 'davi70', skin = 61 where id = 1;

alter table contas add column cargo varchar(70) default 'desempregado' after skin;
alter table contas add column nivel int default 0 after nome;

create table veiculos(
    registro int not null auto_increment primary key,
    vID int not null,
    vX float not null,
    vY float not null,
    vZ float not null,
    vROT float not null,
    cor1 int not null default 158,
    cor2 int not null default 158,
    pID int not null,
    numPosse int not null,
    foreign key (pID) references contas (id)
);
select * from veiculos;
select * from veiculos where pID = 1;

alter table contas add column estrelas int not null default 0;