select 
is_read_committed_snapshot_on as RCSI,
snapshot_isolation_state as SI,
*
from
sys.databases where name='adventureworks'


select *from HumanResources.Employee with (readuncommitted)
select *from HumanResources.Employee with (nolock)


Alter database adventureworks set read_committed_snapshot on with rollback immediate

begin tran

update HumanResources.Employee set Title='dod' where EmployeeID=2
select *from HumanResources.Employee where EmployeeID=2

rollback

	
	-- demo of SI - Transactional 
	
	Alter database adventureworks set read_committed_snapshot off with rollback immediate
	Alter database adventureworks set allow_snapshot_isolation on -- with rollback immediate


begin tran

update HumanResources.Employee set Title='dod' where EmployeeID=2
select *from HumanResources.Employee where EmployeeID=2
	

rollback

-- let us enable both

Alter database adventureworks set read_committed_snapshot on with rollback immediate
	Alter database adventureworks set allow_snapshot_isolation on -- with rollback immediate

select 
is_read_committed_snapshot_on as RCSI,
snapshot_isolation_state as SI,
*
from
sys.databases where name='adventureworks'

begin tran

update HumanResources.Employee set Title='dod' where EmployeeID=2
select *from HumanResources.Employee where EmployeeID=2
	
commit	