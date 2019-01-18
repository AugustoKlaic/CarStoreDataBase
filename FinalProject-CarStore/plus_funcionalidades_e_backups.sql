use Trab_Final
go

-- Backup Full
backup database Trab_Final to disk = 'C:\BACKUP\Trab_Final_FULL.BAK' with retaindays = 5
go

-- Backup Log
backup log Trab_Final to disk = 'C:\BACKUP\Trab_Final_LOG.TRN' with retaindays = 5
go

--plus funcionalidades

--questao 3 
--policies funcionando

--setando pra full recovery mode -- funcionando
--nome da policy 'PL_RECOVERY_MODE'

--Botar mixed login --funcionando
--nome da policy 'PL_MIXED_LOGIN'

--Nomes das tabelas --funcionando
--nome da policy 'PL_TABLE_NAMES'
