use Trab_Final
go

--Questao 1 -- funcionando
create view VW_NOTAS_FISCAIS
as
	select	n1.id_nf1 as 'Nota fiscal',
			c.nome_cidade as 'Cidade',
			est.nome_estado as 'Estado',
			cli.nome_cliente as 'Cliente',
			p.nome_prod as 'Produto',
			g.nome_grupo as 'Tipo'
	from TB_NF2 as n2
inner join TB_NF1 as n1 on n2.nf1_nf2 = n1.id_nf1
inner join TB_PRODUTOS as p on n2.produto_nota = p.id_prod
inner join TB_CIDADES as c on n1.cidade_nota = c.id_cidade
inner join TB_GRUPOS as g on p.grupo_prod = g.id_grupo
inner join TB_CLIENTES as cli on n1.cliente_nota = cli.id_cliente
inner join TB_ESTADOS as est on c.estado_da_cidade = est.uf
go
                      
select * from VW_NOTAS_FISCAIS -- chamada da view
go

--Questao 2 --funcionando
create function UDF_NOTAS_FISCAIS(@nome_cli varchar(100), @periodo_entrada date, @periodo_saida date)
returns table
as return(
		select	n1.id_nf1 as 'Nota fiscal',
			c.nome_cidade as 'Cidade',
			est.nome_estado as 'Estado',
			cli.nome_cliente as 'Cliente',
			p.nome_prod as 'Produto',
			g.nome_grupo as 'Tipo'
	from TB_NF2 as n2
inner join TB_NF1 as n1 on n2.nf1_nf2 = n1.id_nf1
inner join TB_PRODUTOS as p on n2.produto_nota = p.id_prod
inner join TB_CIDADES as c on n1.cidade_nota = c.id_cidade
inner join TB_GRUPOS as g on p.grupo_prod = g.id_grupo
inner join TB_CLIENTES as cli on n1.cliente_nota = cli.id_cliente
inner join TB_ESTADOS as est on c.estado_da_cidade = est.uf
where ((cli.nome_cliente = @nome_cli) and (n1.data_nota >= coalesce(@periodo_entrada, n1.data_nota)) and (n1.data_nota <= coalesce(@periodo_saida,n1.data_nota))) or 
	  ((@nome_cli is null) and (n1.data_nota >= coalesce(@periodo_entrada, n1.data_nota)) and (n1.data_nota <= coalesce(@periodo_saida,n1.data_nota)))
)
go

select * from dbo.UDF_NOTAS_FISCAIS('' ,null ,null) -- chamada da funcao
go

--Questao 3 - funcionando
create nonclustered index IX_NF1 on TB_NF1(id_nf1) 
create nonclustered index IX_NF2 on TB_NF2(id_nf2)
create nonclustered index IX_CIDADES on TB_CIDADES(id_cidade)
create nonclustered index IX_CLIENTES on TB_CLIENTES(id_cliente)
create nonclustered index IX_ESTADOS on TB_ESTADOS(uf)
create nonclustered index IX_GRUPOS on TB_GRUPOS(id_grupo)
create nonclustered index IX_PRODUTOS on TB_PRODUTOS(id_prod)
go

--questao 4 --funcionando
create procedure SP_AUMENTO_DE_PRECO
	@valor money,
	@prod varchar(20),
	@grupo int

as
begin
	update TB_PRODUTOS set preco_prod = @valor where (nome_prod = @prod) or (grupo_prod = @grupo )
end
go

exec SP_AUMENTO_DE_PRECO 0000.00, '', null -- chamada da procedure
go

--Questao 5 --funcionando
create procedure SP_RELATORIO
	@nome varchar(20)

as
begin
	select  cli.nome_cliente as 'Cliente',
	(select p.nome_prod + ' ,'
	from TB_PRODUTOS as p 
inner join TB_NF2 as n2 on p.id_prod = n2.produto_nota
inner join TB_NF1 as n1 on n2.nf1_nf2 = n1.id_nf1
where cli.id_cliente = n1.cliente_nota
for XML PATH('')
)  as 'Produtos'
from  TB_CLIENTES as cli
where (cli.nome_cliente = @nome)
group by cli.nome_cliente, cli.id_cliente
end
go

exec SP_RELATORIO 'Augusto da Silva' -- chamada da procedure
go

--questao 6 --aparentemente ta ok
create trigger TG_CLIENTES on TB_CLIENTES
instead of delete
as
begin
    set nocount on;
    update TB_CLIENTES set ativo = 'N'
    from TB_CLIENTES
    inner join deleted on deleted.id_cliente = TB_CLIENTES.id_cliente
end
go