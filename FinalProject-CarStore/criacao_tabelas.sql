create database Trab_Final
go

use Trab_Final
go

create table TB_ESTADOS(
	uf char(2) primary key not null,
	nome_estado varchar(50) not null
) on 'PRIMARY'

create table TB_CIDADES(
	id_cidade int primary key not null,
	nome_cidade varchar(100) not null,
	estado_da_cidade char(2) not null,

	constraint FK_CIDADES_ESTADOS foreign key(estado_da_cidade) references TB_ESTADOS(uf)
) on 'PRIMARY'

create table TB_CLIENTES(
	id_cliente int identity(1,1) primary key not null,
	nome_cliente varchar(100) not null,
	data_cadastro datetime default getdate() not null,
	ativo char(1) not null
) on 'PRIMARY'

create table TB_GRUPOS(
	id_grupo int identity(1,1) primary key not null,
	nome_grupo varchar(50) not null,
	ativo char(1) default ('S')
) on 'PRIMARY'

create table TB_PRODUTOS(
	id_prod int identity(1,1) primary key not null,
	nome_prod varchar(100) not null,
	grupo_prod int not null,
	preco_prod money check (preco_prod > 0) not null,
	data_cadastro datetime default getdate() not null,

	constraint FK_PRODUTOS_GRUPOS foreign key(grupo_prod) references TB_GRUPOS(id_grupo)
) on 'PRIMARY'

create table TB_NF1(
	id_nf1 int identity(1,1) primary key not null,
	data_nota datetime not null,
	cidade_nota int not null,
	cliente_nota int not null,

	constraint FK_NF1_CIDADE foreign key(cidade_nota) references TB_CIDADES(id_cidade),
	constraint FK_NF1_CLIENTES foreign key(cliente_nota) references TB_CLIENTES(id_cliente)
)on 'SECONDARY'

create table TB_NF2(
	id_nf2 int identity(1,1) primary key not null,
	nf1_nf2 int not null,
	produto_nota int not null,
	quantidade int not null default 0,
	preco_total money not null default 0,
	
	constraint FK_NF2_NF1 foreign key(nf1_nf2) references TB_NF1(id_nf1),
	constraint FK_NF2_PRODUTOS foreign key(produto_nota) references TB_PRODUTOS(id_prod)
) on 'SECONDARY'
go