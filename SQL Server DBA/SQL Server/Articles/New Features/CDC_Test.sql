USE Suthan;
go

-- 1. CDC enabling procedure - need to enable at a database level (Log reader agent will be created)
execute sys.sp_cdc_enable_db;
select is_cdc_enabled from sys.databases where database_id = DB_ID()

-- 2. Create a table
create table Test_CDC 
(
	line_item_id int identity(1,1) primary key, 
	line_item_name varchar(200) not null, 
	plan_id int not null,
	planned_start_date date not null,
	planned_end_date date not null,
	planned_effort float not null,
	actual_start_date date,
	actual_end_date date,
	actual_effort float
);

-- 3. Mark this table to be tracked
execute sp_cdc_enable_table 
	    @source_schema = N'dbo', 
	    @source_name = N'Test_CDC', 
	    @role_name = N'cdc';

-- 4. Lets try some DML and see how it is captured by CDC
-- 4.1. Inserting 2 rows
insert into Test_CDC (
	line_item_name,
	plan_id,
	planned_start_date,
	planned_end_date,
	planned_effort)
values ('Checking Change data capture2',
		1,
		'2011-04-30',
		'2011-05-06',
		40),
		('Checking Change data capture2',
		2,
		'2013-04-30',
		'2013-05-06',
		40);

-- 4.2. Update one of those rows
update Test_CDC
set line_item_name = 'Checking update in CDC - 2',
	planned_start_date = '2011-05-03',
	planned_effort = 32
where line_item_id = 5;

select * from Test_CDC
--delete test_cdc

-- 5. Lets check some general CDC stuff	    
execute sys.sp_cdc_help_change_data_capture 
select * from cdc.lsn_time_mapping

select * from cdc.dbo_Test_CDC_CT;

-- 6. Lets now query for the changes done in the past one hour
-- 6.1. All changes
select * from cdc.fn_cdc_get_all_changes_dbo_test_cdc (
	sys.fn_cdc_map_time_to_lsn ('smallest greater than', dateadd(hour, -1, getdate())),
	sys.fn_cdc_map_time_to_lsn ('largest less than or equal', getdate()),
	'all');

-- 6.2. Net changes
select * from cdc.fn_cdc_get_net_changes_dbo_test_cdc (
	sys.fn_cdc_map_time_to_lsn ('smallest greater than', dateadd(hour, -1, getdate())),
	sys.fn_cdc_map_time_to_lsn ('largest less than or equal', getdate()),
	'all');
	
