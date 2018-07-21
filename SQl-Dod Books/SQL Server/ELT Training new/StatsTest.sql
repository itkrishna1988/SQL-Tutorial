

-- Creation script

Use Test_xml

if object_id('Stest') <>0
Drop table Stest

Create table Stest
(
Id int identity(1,1),
Name varchar(255)
)

if object_id('statsDetail') <>0
Drop table statsDetail

Create table statsDetail
(
StatsDate datetime,
StartCount int,
ResetCount int

)

Create index ix_name on stest(name)

go 

insert into stest
select name from syscolumns

GO 10

/*
select name from stest where Name ='Good' option(recompile)

Select rowcnt,rowmodctr from sysindexes where id=OBJECT_ID('stest')
and name ='ix_name'

dbcc show_statistics(stest,ix_name)

*/

-- Populate data and collect stats update details




SET NOCOUNT ON

Declare @StartCount int
Declare @ResetCount int
Declare @Loopvar int
Declare @DumVar varchar(255)


Select @StartCount=rowcnt from sysindexes where id=OBJECT_ID('stest')
and name ='ix_name'
Set @Loopvar=0


While @Loopvar<=1000
Begin

insert into stest
select name from syscolumns



Select @ResetCount=rowmodctr from sysindexes where id=OBJECT_ID('stest')
and name ='ix_name'

select @DumVar=name from stest where Name ='Test'
 Option (recompile) 
 
 
IF Exists
(Select 1 from sysindexes where id=OBJECT_ID('stest')
and name ='ix_name' and rowmodctr=0)
Begin 



insert into STatsDetail
values
(GETDATE(),@StartCount,@ResetCount)

Select @StartCount=rowcnt from sysindexes where id=OBJECT_ID('stest')
and name ='ix_name'
End


Set @Loopvar=@Loopvar+1

End


select *,cast( (ResetCount) AS float)/ StartCount * 100 PercentChanged
 from STatsDetail