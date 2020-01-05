/* to demonstrate change data capture */

/* create a database */
create database cdctest
go

/* query to verify if object cdc exists in the database created */
/* if object cdc exists,query displays object details */
Use cdctest
Select * From sys.objects o
inner join sys.schemas s
on o.schema_id=s.schema_id and s.name ='cdc'  
go

/* query to find if a trigger is set on any object */
select *from sys.triggers
go

/* query to enable cdc on the database created */
Exec sys.sp_cdc_enable_db
go



/* create a table to demonstarte cdc */
create table cdctesttable
(col int identity primary key,
name varchar(10),
address varchar(1000))

/* insert values intot he table */
insert cdctesttable select 'aaa','mepz'
insert cdctesttable select 'bbb','mepz'
insert cdctesttable select 'ccc','mepz'
go

/* query to enable cdc on this table */

Exec sys.sp_cdc_enable_table @source_schema='dbo',@source_name='cdctesttable',@role_name=null
/*
You can specify Filegroup/indexes/columnlist while configuring cdc for table
*/

/*
Job 'cdc.cdctest_capture' started successfully.
Job 'cdc.cdctest_cleanup' started successfully.
*/


/* query to verify if object cdc exists in the database created */
/* if object cdc exists,query displays object details */
Select *From sys.objects o
inner join sys.schemas s
on o.schema_id=s.schema_id and s.name ='cdc'  

-- You can see a function for this table - fn_cdc_get_all_changes_dbo_cdctesttable
-- And also table dbo_cdctesttable_CT



/* query to display which table is enabled for CDC */
select *From cdc.change_tables

/* query to display the columns enabled with CDC */ 
	select *From cdc.captured_columns

/* query to get more info and additional metadata */
Exec sys.sp_cdc_help_change_data_capture 

/* Let us insert and update some values into the table to understand cdc */

insert cdctesttable select 'ddd','mepz';
update   cdctesttable set address='gmr' where col=1;

/* select query to see what is there in cdc table */

select *from cdc.dbo_cdctesttable_CT

/* You can also use fn_cdc_get_all_changes_dbo_cdctesttable funciton */

declare @from_lsn binary(10), @to_lsn binary (10)
Set @from_lsn=sys.fn_cdc_get_min_lsn('dbo_cdctesttable')
set @to_lsn=sys.fn_cdc_get_max_lsn()
select *From cdc.fn_cdc_get_all_changes_dbo_cdctesttable(@from_lsn,@to_lsn,'all' )


/* to see whats inside */
EXEC sp_helptext 'cdc.fn_cdc_get_all_changes_dbo_cdctesttable'

declare @from_lsn binary(10), @to_lsn binary (10)
Set @from_lsn=sys.fn_cdc_get_min_lsn('dbo_cdctesttable')
set @to_lsn=sys.fn_cdc_get_max_lsn()
select *From cdc.fn_cdc_get_all_changes_dbo_cdctesttable (@from_lsn,@to_lsn ,'all')
 

/* Object to see the LSN to time mapping */

Select *from  cdc.lsn_time_mapping

/* to check if any error */
select *from sys.dm_cdc_errors
go

/* query to disable cdc on the database created */
Exec sys.sp_cdc_disable_db


/* drop database cdctest */
use Master
go
Alter database cdctest set Single_user with Rollback immediate
GO
Drop database cdctest
go
