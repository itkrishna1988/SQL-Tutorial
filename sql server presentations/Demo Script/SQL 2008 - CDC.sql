drop database cdctest
go
create database cdctest
go
use cdctest
Select *From sys.objects o
inner join sys.schemas s
on o.schema_id=s.schema_id and s.name ='cdc'  
go
select *from sys.triggers
go
Exec sys.sp_cdc_enable_db
go
--Exec sys.sp_cdc_disable_db
 Select distinct o.name From sys.objects o where o.name like '%cdc%'
go

create table cdctesttable
(col int identity primary key,
name varchar(10),
address varchar(1000))

insert cdctesttable select 'madhu','mepz'
insert cdctesttable select 'aa','mepz'
insert cdctesttable select 'bb','mepz'
go

--Enable cdc on this table

Exec sys.sp_cdc_enable_table @source_schema='dbo',@source_name='cdctesttable',@role_name=null
/*
You can specify Filegroup/indexes/columnlist while configuring cdc for table
*/

/*
Job 'cdc.cdctest_capture' started successfully.
Job 'cdc.cdctest_cleanup' started successfully.
*/
Select *From sys.objects o
inner join sys.schemas s
on o.schema_id=s.schema_id and s.name ='cdc'  

-- You can see a function for this table - fn_cdc_get_all_changes_dbo_cdctesttable
-- And also table dbo_cdctesttable_CT

	select *from sys.triggers
-- to check which table  is enabled for CDC

	select *From cdc.change_tables
	select *From cdc.captured_columns

-- You can get more info and additional metadata by
Exec sys.sp_cdc_help_change_data_capture 

-- Let us see how it works

insert cdctesttable select 'dd','mepz'
update   cdctesttable set address='gmr' where col=1

-- see what is there in cdc table
select *from cdc.dbo_cdctesttable_CT

-- You can also use fn_cdc_get_all_changes_dbo_cdctesttable funciton

declare @from_lsn binary(10), @to_lsn binary (10)
Set @from_lsn=sys.fn_cdc_get_min_lsn('dbo_cdctesttable')
set @to_lsn=sys.fn_cdc_get_max_lsn()
select *From cdc.fn_cdc_get_all_changes_dbo_cdctesttable(@from_lsn,@to_lsn,'all' )

-- to see whats inside
sp_helptext 'cdc.fn_cdc_get_all_changes_dbo_cdctesttable'

declare @from_lsn binary(10), @to_lsn binary (10)
Set @from_lsn=sys.fn_cdc_get_min_lsn('dbo_cdctesttable')
set @to_lsn=sys.fn_cdc_get_max_lsn()
select *From cdc.fn_cdc_get_all_changes_dbo_cdctesttable (@from_lsn,@to_lsn ,'all')
 

-- Object to see the LSN to time mapping

Select *from  cdc.lsn_time_mapping

-- if any error happend
select *from sys.dm_cdc_errors

go
use Master
go
Alter database cdctest set Single_user with Rollback immediate
GO
Drop database cdctest
go
