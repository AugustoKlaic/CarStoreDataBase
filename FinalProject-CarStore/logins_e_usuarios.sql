use Trab_Final
go

create role Administrativo
grant insert, delete on TB_CIDADES to Administrativo
grant insert, delete on TB_CLIENTES to Administrativo
grant insert, delete on TB_ESTADOS to Administrativo
grant insert, delete on TB_GRUPOS to Administrativo
grant insert, delete on TB_NF1 to Administrativo
grant insert, delete on TB_NF2 to Administrativo
grant insert, delete on TB_PRODUTOS to Administrativo
go

create role Vendas
grant insert, delete on TB_NF1 to Vendas
grant insert, delete on TB_NF2 to Vendas
grant select on TB_CIDADES to Vendas
grant select on TB_CLIENTES to Vendas
grant select on TB_ESTADOS to Vendas
grant select on TB_GRUPOS to Vendas
grant select on TB_PRODUTOS to Vendas
go

create login Maria with password = '12345', check_policy= off, check_expiration = off
create user Maria for login Maria
go
create login Paulo with password = '54321', check_policy= off, check_expiration = off
create user Paulo for login Paulo
go
create login Fernando with password = '11111', check_policy= off, check_expiration = off
create user Fernando for login Fernando
go
create login Marcelo with password = '00000', check_policy= off, check_expiration = off
create user Marcelo for login Marcelo
go

alter role Administrativo add member Maria
alter role Administrativo add member Paulo
alter role Vendas add member Fernando
alter role Vendas add member Marcelo
go

