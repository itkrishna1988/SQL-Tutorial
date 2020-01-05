create proc spcachedplantest
@i int
as
select EmployeeID from HumanResources.Employee where EmployeeID=@i -- different value

go
Alter proc spRecomp
@title varchar(40)
-- with recompile
as
select *from TempEmp where Title like @title
--option (recompile)
go

select *into tempEmp from  HumanResources.Employee
insert into TempEmp(
NationalIDNumber,
ContactID,
LoginID,
ManagerID,
Title,
BirthDate,
MaritalStatus,
Gender,
HireDate,
SalariedFlag,
VacationHours,
SickLeaveHours,
CurrentFlag,
rowguid,
ModifiedDate) select 

NationalIDNumber,
ContactID,
LoginID,
ManagerID,
Title,
BirthDate,
MaritalStatus,
Gender,
HireDate,
SalariedFlag,
VacationHours,
SickLeaveHours,
CurrentFlag,
rowguid,
ModifiedDate
from HumanResources.Employee
where EmployeeID=2
go 20


insert into TempEmp(
NationalIDNumber,
ContactID,
LoginID,
ManagerID,
Title,
BirthDate,
MaritalStatus,
Gender,
HireDate,
SalariedFlag,
VacationHours,
SickLeaveHours,
CurrentFlag,
rowguid,
ModifiedDate) select 
 

NationalIDNumber,
ContactID,
LoginID,
ManagerID,
'dod',
BirthDate,
MaritalStatus,
Gender,
HireDate,
SalariedFlag,
VacationHours,
SickLeaveHours,
CurrentFlag,
rowguid,
ModifiedDate
from HumanResources.Employee
where EmployeeID=2

select column_name+',' from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='TempEmp'

select *from TempEmp

create index idx_nci on TempEmp(Title)


sp_help 'HumanResources.Employee'
set statistics io on
exec spRecomp 'dod1'
exec spRecomp 'P%'  
exec spRecomp 'P%' with recompile


spcachedplantest '10'

-- Demo recompile
-- Demo parameter sniffing
-- with recompile inside sp and sp execution
